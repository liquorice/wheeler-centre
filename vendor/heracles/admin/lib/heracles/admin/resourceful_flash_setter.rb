module Heracles
  module Admin
    class ResourcefulFlashSetter
      class << self
        attr_accessor :flash_keys, :namespace_lookup, :helper
      end

      self.flash_keys = [:notice, :alert]
      self.namespace_lookup = false
      self.helper = Object.new.extend(
        ActionView::Helpers::TranslationHelper,
        ActionView::Helpers::TagHelper
      )

      DEFAULT_ACTIONS_FOR_VERBS = {
        post:   :new,
        patch:  :edit,
        put:    :edit
      }

      attr_reader :controller, :request, :format, :resource

      delegate :get?, to: :request

      def initialize(controller, resource, options={})
        # Controller environment
        @controller = controller
        @request = @controller.request
        @format = @controller.formats.first
        @resource = resource
        @action = options.delete(:action)

        # Flash handling options
        @flash     = options.delete(:flash)
        @notice    = options.delete(:notice)
        @alert     = options.delete(:alert)
        @flash_now = options.delete(:flash_now) { :on_failure }
      end

      def self.call(*args)
        new(*args).set_flash_message
      end

      def set_flash_message
        set_flash_message! if set_flash_message?
      end

      protected

      def set_flash_message!
        if has_errors?
          status = self.class.flash_keys.last
          set_flash(status, @alert)
        else
          status = self.class.flash_keys.first
          set_flash(status, @notice)
        end

        return if controller.flash[status].present?

        options = mount_i18n_options(status)
        message = self.class.helper.t options[:default].shift, options
        set_flash(status, message)
      end

      def set_flash(key, value)
        return if value.blank?
        flash = controller.flash
        flash = flash.now if set_flash_now?
        flash[key] ||= value
      end

      def set_flash_now?
        @flash_now == true || format == :js ||
          (default_action && (has_errors? ? @flash_now == :on_failure : @flash_now == :on_success))
      end

      def set_flash_message? #:nodoc:
        !get? && @flash != false
      end

      def mount_i18n_options(status) #:nodoc:
        resource_name = if resource.class.respond_to?(:model_name)
          resource.class.model_name.human
        else
          resource.class.name.underscore.humanize
        end

        options = {
          default: flash_defaults_by_namespace(status),
          resource_name: resource_name,
          downcase_resource_name: resource_name.downcase
        }

        if controller.respond_to?(:interpolation_options, true)
          options.merge!(controller.send(:interpolation_options))
        end

        options
      end

      def flash_defaults_by_namespace(status) #:nodoc:
        defaults = []
        slices   = controller.controller_path.split('/')
        lookup   = self.class.namespace_lookup

        begin
          controller_scope = :"flash.#{slices.fill(controller.controller_name, -1).join('.')}.#{controller.action_name}.#{status}"

          actions_scope = lookup ? slices.fill('actions', -1).join('.') : :actions
          actions_scope = :"flash.#{actions_scope}.#{controller.action_name}.#{status}"

          defaults << :"#{controller_scope}_html"
          defaults << controller_scope

          defaults << :"#{actions_scope}_html"
          defaults << actions_scope

          slices.shift
        end while slices.size > 0 && lookup

        defaults << ""
      end

      def has_errors?
        resource.respond_to?(:errors) && !resource.errors.empty?
      end

      def default_action
        @action ||= DEFAULT_ACTIONS_FOR_VERBS[request.request_method_symbol]
      end
    end
  end
end
