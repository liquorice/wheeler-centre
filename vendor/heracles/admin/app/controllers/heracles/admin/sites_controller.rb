module Heracles
  module Admin
    class SitesController < ApplicationController
      self.policy_class = SitePolicy

      expose(:sites_scope) { policy_scope(Heracles::Site) }
      expose(:all_sites) { sites_scope.order(:slug) }
      expose(:all_site, ancestor: :sites_scope, model: "heracles/site", finder: :find_by_slug)

      respond_to :html

      before_filter :redirect_to_only_site, only: :index

      def index
      end

      def show
        redirect_to site_pages_path(all_site)
      end

      def new
        authorize all_site
      end

      def create
        authorize all_site

        if all_site.save
          publish_site_update_event
        end

        respond_with all_site, location: sites_path
      end

      def edit
        authorize all_site
      end

      def update
        authorize all_site

        if all_site.save
          publish_site_update_event
        end

        respond_with all_site, location: sites_path
      end

      def destroy
        authorize all_site

        all_site.destroy
        respond_with all_site
      end

      private

      def redirect_to_only_site
        redirect_to site_pages_path(all_sites.first) if all_sites.length == 1 && !heracles_admin_current_user.heracles_superadmin?
      end

      def publish_site_update_event
        ActiveSupport::Notifications.instrument "heracles.site.updated", site_id: all_site.id
      end
    end
  end
end
