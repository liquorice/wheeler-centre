require "uri"

module Heracles
  module CloudinaryAssetProcessor
    extend self

    def processor_name
      :cloudinary
    end

    def requires_initial_processing?
      false
    end

    def process_asset(asset)
      # No op
    end

    def cloudinary_options_for_site(site)
      {
        cloud_name: site.configuration.cloudinary_cloud_name,
        api_key: site.configuration.cloudinary_api_key,
        api_secret: site.configuration.cloudinary_api_secret,
        cdn_subdomain: site.configuration.cloudinary_cdn_subdomain,
        secure: site.configuration.use_ssl_for_asset_urls
      }
    end
  end
end
