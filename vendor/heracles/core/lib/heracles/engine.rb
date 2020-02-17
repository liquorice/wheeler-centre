module Heracles
  class Engine < ::Rails::Engine
    engine_name "heracles"

    initializer "heracles.core.eager_load" do |app|
      app.config.eager_load_namespaces << self

      # Force an eager load on each request in order to ensure all of our class
      # loading techniques (string constantizing and descendant tracking) work
      # reliably in development mode.
      core_engine  = self
      site_engines = []

      begin
        Heracles::Site.servable.each do |site|
          site_engines << site.engine
        end
      rescue => e
        puts "* Error eager-loading public site engines: #{e.message}"
      end

      if !app.config.eager_load
        ActionDispatch::Reloader.to_prepare do
          # Eager load the application so we can look up page types.
          app.eager_load!

          # Eager load this engine, so we can look up field types.
          core_engine.eager_load!

          site_engines.compact.each do |site_engine|
            site_engine.eager_load!
          end
        end
      end
    end

    initializer "heracles.core.public_pages.register_lookup_details" do
      ActionView::LookupContext.register_detail(:public_page_type) { [] }
      ActionView::LookupContext.register_detail(:public_page_template) { [] }
    end

    rake_tasks do
      load "heracles/rails/rake_tasks.rb"
    end
  end
end
