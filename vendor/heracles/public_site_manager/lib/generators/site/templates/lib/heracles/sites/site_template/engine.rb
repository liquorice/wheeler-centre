module Heracles
  module Sites
    module <%= camel_case_site_name %>
      class Engine < ::Rails::Engine
        isolate_namespace Heracles::Sites::<%= camel_case_site_name %>

        initializer :assets do |app|
          app.config.assets.precompile += %w( heracles/sites/<%= snake_case_site_name %>/public.css heracles/sites/<%= snake_case_site_name %>/public.js )
          app.config.assets.precompile += %w( heracles/sites/<%= snake_case_site_name %>/admin.css  heracles/sites/<%= snake_case_site_name %>/admin.js )
        end
      end
    end
  end
end
