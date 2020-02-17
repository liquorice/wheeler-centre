module Heracles
  module AdminUserAuth
    class Engine < ::Rails::Engine
      isolate_namespace Heracles::AdminUserAuth

      initializer "heracles_admin_user_auth.set_user_classes" do
        Heracles.user_class = "Heracles::User"
        Heracles.site_administration_class = "Heracles::SiteAdministration"
      end

      config.to_prepare do
        Heracles::Admin::ApplicationController.send :include, Heracles::AdminUserAuth::AdminAuthenticationHelpers
      end
    end
  end
end
