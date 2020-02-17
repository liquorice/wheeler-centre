module Heracles
  module PublicSiteManager
    class Engine < ::Rails::Engine
      engine_name "heracles_public_site_manager"
      isolate_namespace PublicSiteManager

      initializer "heracles.public_site_manager.routes.reload_when_site_updated" do |app|
        ActiveSupport::Notifications.subscribe "heracles.site.updated" do |name, start, finish, id, payload|
          Rails.application.reload_routes!
        end
      end
    end
  end
end
