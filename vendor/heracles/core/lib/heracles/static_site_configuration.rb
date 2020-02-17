module Heracles
  module StaticSiteConfiguration
    class Configuration
      attr_accessor :configuration_page_url

      attr_accessor :render_content_defaults

      attr_accessor :asset_processors

      attr_accessor :aws_s3_access_key_id
      attr_accessor :aws_s3_secret_access_key
      attr_accessor :aws_s3_region
      attr_accessor :aws_s3_bucket
      attr_accessor :aws_s3_prefix

      attr_accessor :cloudinary_cloud_name
      attr_accessor :cloudinary_api_key
      attr_accessor :cloudinary_api_secret
      attr_accessor :cloudinary_cdn_subdomain
      attr_accessor :cloudinary_base_mapping

      attr_accessor :transloadit_auth_key
      attr_accessor :transloadit_auth_secret
      attr_accessor :transloadit_assembly_steps

      attr_accessor :use_ssl_for_asset_urls
      attr_accessor :use_notifications_for_asset_processing

      def initialize
        @configuration_page_url = "settings"
        @render_content_defaults = {}
        @asset_processors = []
        @use_ssl_for_asset_urls = false
        @use_notifications_for_asset_processing = false
      end
    end

    # Public: Returns the site configuration.
    def configuration
      @configuration ||= Configuration.new
    end

    # Public: Set the site configuration.
    def configuration=(new_configuration)
      @configuration = new_configuration
    end

    # Public: Modify the current site configuration.
    #
    # Yields the current site configuration object.
    def configure
      yield configuration
    end
  end
end
