module Heracles
  module Admin
    class ApplicationController < ActionController::Base
      self.responder = AdminResponder

      decent_configuration do
        strategy PolicyParametersStrategy
      end

      include Policy

      layout "heracles/admin/admin"

      before_filter :set_cache_headers
      before_filter :authenticate_heracles_admin_user

      expose(:available_sites) { Heracles.site_administration_class.sites_administerable_by(heracles_admin_current_user) }
      expose(:site) { available_sites.find_by_slug(params[:site_id]) }

      protected

      def set_cache_headers
        # Admin pages should never be cached. Set this explicitly, just in
        # case the container app has set Cache-Control headers in
        # `config.action_dispatch.default_headers`.
        response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
      end

      def authenticate_heracles_admin_user
        unless heracles_admin_current_user && heracles_admin_current_user.heracles_admin?
          store_location

          if respond_to?(:heracles_admin_login_path)
            redirect_to heracles_admin_login_path
          else
            redirect_to main_app.root_path
          end
        end
      end

      def store_location
        authentication_routes = %i(heracles_admin_login_path heracles_admin_logout_path)
        disallowed_urls = authentication_routes.map { |route| try(route) }.compact

        unless disallowed_urls.include?(request.fullpath)
          session["heracles_admin_user_return_to"] = request.fullpath
        end
      end
    end
  end
end
