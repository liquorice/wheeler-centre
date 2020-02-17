module Heracles
  module Admin
    class Engine < ::Rails::Engine
      engine_name "heracles_admin"
      isolate_namespace Heracles::Admin

      initializer "heracles.admin.eager_load" do |app|
        app.config.eager_load_namespaces << self

        # For some reason this is needed for the `Policy` concern to mix into
        # controllers properly.
        # TODO: find a way to avoid this.
        eager_load! if !app.config.eager_load
      end

      initializer "heracles.admin.assets.react.configure", before: "react_rails.setup_vendor" do |app|
        app.config.react.variant = Rails.env.to_sym
        app.config.react.addons = true
      end

      initializer "heracles.admin.assets.precompile" do |app|
        app.config.assets.precompile += %w(
          heracles/admin/admin.css
          heracles/admin/admin-loader.js
          heracles/admin/admin.js
          heracles/sites/*/admin.js
          heracles/sites/*/admin.css
          tinymce/themes/basic/admin_content_editor.css
          heracles/sites/*/admin_content_editor.css)
      end
    end
  end
end
