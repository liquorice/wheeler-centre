module Heracles
  module PublicSiteManager
    class SiteHostConstraint
      def initialize(site)
        @site = site
        @hostnames = @site.all_hostnames
        if admin_host.present?
          @hostnames << "#{@site.slug}.#{admin_host}"
        end
      end

      def matches?(request)
        if @hostnames.include?(request.host_with_port)
          # Reload the site on every request for now
          request.env["heracles.site"] = @site.class.find(@site.id)
        end
      end

      private

      def admin_host
        @admin_host ||= Heracles.configuration.admin_host
      end
    end
  end
end
