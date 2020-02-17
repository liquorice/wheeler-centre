module Heracles
  module Admin
    module FormsHelper
      def form_errors_panel(form)
        if form.object.errors.present?
          content_tag :div, class: "form-errors copy" do
            if (intro_message = form_message(form, "errors_intro")).present?
              concat content_tag(:div, intro_message, class: "form-errors__intro")
            end

            messages = content_tag :ul, class: "form-errors__list" do
              safe_join(form.object.errors.full_messages.map { |message| content_tag(:li, message, class: "form-errors__list-item") })
            end
            concat messages

            if (outro_message = form_message(form, "errors_outro")).present?
              concat content_tag(:div, outro_message, class: "form-errors__outro")
            end
          end
        end
      end

      def form_field_errors(form, field)
        if form.object.errors[field].present?
          content_tag :div, class: "form-errors copy" do
            form.object.errors[field].to_a.uniq.each do |message|
              message = message.capitalize
              message += "." unless message =~ /\.$/

              concat content_tag(:p, message)
            end
          end
        end
      end

      private

      def form_message(form, i18n_key)
        resource_name = if form.object.class.respond_to?(:model_name)
          form.object.class.model_name.human
        else
          form.object.class.name.underscore.humanize
        end

        i18n_options = {
          default: contextual_i18n_defaults("forms", i18n_key),
          resource_name: resource_name,
          downcase_resource_name: resource_name.downcase
        }

        if controller.respond_to?(:interpolation_options, true)
          i18n_options.merge!(controller.send(:interpolation_options))
        end

        t(i18n_options[:default].shift, i18n_options)
      end

      def contextual_i18n_defaults(front_keys, rear_keys)
        defaults    = []
        front_keys  = "#{front_keys}."  if front_keys.present?
        rear_keys   = ".#{rear_keys}"   if rear_keys.present?
        slices      = controller.controller_path.split('/')

        begin
          controller_scope  = :"#{front_keys}#{slices.fill(controller.controller_name, -1).join('.')}.#{controller.action_name}#{rear_keys}"
          actions_scope     = slices.fill("actions", -1).join(".")
          actions_scope     = :"#{front_keys}#{actions_scope}.#{controller.action_name}#{rear_keys}"

          defaults << :"#{controller_scope}_html"
          defaults << controller_scope

          defaults << :"#{actions_scope}_html"
          defaults << actions_scope

          slices.shift
        end while slices.size > 0

        defaults << ""
      end
    end
  end
end
