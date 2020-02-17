require "render_anywhere"

module Heracles
  class InsertableRenderer
    include RenderAnywhere

    class_attribute :helper_methods

    attr_accessor :data, :options

    def self.helper_method(method_name)
      self.helper_methods ||= []
      self.helper_methods += [method_name]
    end

    def initialize(insertable_data={}, options={})
      @data     = insertable_data.deep_symbolize_keys
      @options  = options.deep_symbolize_keys
    end

    helper_method \
    def site
      @options[:site]
    end

    def render
      raise "must not be called directly on #{self.class.name} base class" if insertable_name == "insertable"

      # Provide all the template accessors as locals
      locals = Hash[ self.class.helper_methods.map { |method_name| [method_name, send(method_name)] } ]

      # Render using RenderAnywhere
      super template: "#{insertable_name}", locals: locals.merge(data: data, options: options), layout: nil
    end

    def rendering_controller
      super.tap do |controller|
        # Specify a custom template lookup path. Insertable templates are
        # looked for in these 2 locations:
        #
        # 1. app/views/insertables/heracles/sites/<site_slug>/<name>_insertable.html.slim (in the main app or site engines)
        # 2. app/views/insertables/heracles/<name>_insertable.html.slim (in the core engine)
        #
        pattern = "{:prefix/,}{insertables/#{site.engine_path}/:action,insertables/heracles/:action,:action}{.:locale,}{.:formats,}{.:handlers,}"
        controller.instance_eval do
          lookup_context.view_paths = nil
          ActionController::Base.view_paths.each do |path|
            append_view_path ActionView::FileSystemResolver.new(path.to_s, pattern)
          end
        end

        # For some reason, RenderAnywhere's controller doesn't respect the
        # application-level perform_caching setting. Re-apply it here to make
        # sure it's in place.
        controller.perform_caching = Rails.application.config.action_controller.perform_caching
      end
    end

    private

    def insertable_name
      self.class.name.demodulize.underscore.sub(/_renderer$/, "")
    end
  end
end
