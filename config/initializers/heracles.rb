Heracles.configure do |config|
  config.admin_host = ENV["HERACLES_ADMIN_HOST"]
  config.embedly_api_key = ENV["EMBEDLY_API_KEY"]
end

module Heracles
  module Sites
    module WheelerCentre
      extend Heracles::StaticSiteConfiguration

      class SiteConfiguration < Heracles::SiteConfiguration
      end
    end
  end
end

# Site configuration
Heracles::Sites::WheelerCentre.configure do |config|
  config.use_notifications_for_asset_processing = true
  config.configuration_page_url = "settings"

  config.asset_processors = [:transloadit]
  config.use_ssl_for_asset_urls = ENV["USE_SSL_FOR_ASSETS"]

  config.aws_s3_access_key_id = ENV["ASSETS_AWS_ACCESS_KEY_ID"]
  config.aws_s3_secret_access_key = ENV["ASSETS_AWS_SECRET_ACCESS_KEY"]
  config.aws_s3_region = ENV["ASSETS_AWS_REGION"]
  config.aws_s3_bucket = ENV["ASSETS_AWS_BUCKET"]
  config.aws_s3_prefix = ENV["ASSETS_AWS_S3_PREFIX"]

  # config.transloadit_auth_key = ENV["TRANSLOADIT_AUTH_KEY"]
  # config.transloadit_auth_secret = ENV["TRANSLOADIT_AUTH_SECRET"]
  # config.transloadit_template_id  = ENV["TRANSLOADIT_TEMPLATE_ID"]
end
