Heracles.configure do |config|
  config.admin_host = ENV["ADMIN_HOST"]
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

  config.transloadit_auth_key = ENV["TRANSLOADIT_AUTH_KEY"]
  config.transloadit_auth_secret = ENV["TRANSLOADIT_AUTH_SECRET"]

  # config.transloadit_assembly_steps = {
  #   "admin_document_thumbnail" => {
  #     "robot" => "/document/thumbs",
  #     "page" => 1,
  #     "width" => 400,
  #     "height" => 250,
  #     "resize_strategy" => "fit",
  #     "background" => "#dddddd",
  #     "colorspace" => "RGB"
  #   },
  #   "admin_thumbnail" => {
  #     "robot" => "/image/resize",
  #     "use" => ":original",
  #     "width" => 400,
  #     "height" => 250,
  #     "resize_strategy" => "fit",
  #     "strip" => true,
  #     "colorspace" => "RGB"
  #   },
  #   "store" => {
  #     "robot" => "/s3/store",
  #     "use" => [
  #       "admin_document_thumbnail",
  #       "admin_thumbnail"
  #     ],
  #     "key" => ENV["ASSETS_AWS_ACCESS_KEY_ID"],
  #     "secret" => ENV["ASSETS_AWS_SECRET_ACCESS_KEY"],
  #     "bucket" => ENV["ASSETS_AWS_BUCKET"],
  #     "path" => "${fields.site_slug}/assets/${unique_original_prefix}/${file.id}_${previous_step.name}.${file.ext}",
  #     "headers" => {
  #       "Cache-Control" => "public, max-age=31536000"
  #     }
  #   },
  #   "store_original" => {
  #     "robot" => "/s3/store",
  #     "use" => [
  #       ":original"
  #     ],
  #     "key" => ENV["ASSETS_AWS_ACCESS_KEY_ID"],
  #     "secret" => ENV["ASSETS_AWS_SECRET_ACCESS_KEY"],
  #     "bucket" => ENV["ASSETS_AWS_BUCKET"],
  #     "path" => "${fields.site_slug}/assets/${unique_original_prefix}/${file.url_name}",
  #     "headers" => {
  #       "Cache-Control" => "public, max-age=31536000"
  #     }
  #   },
  #   "store_youtube" => {
  #     "robot" => "/youtube/store",
  #     "use" => [
  #       ":original"
  #     ],
  #     "credentials" => "youtube_auth_1479859234",
  #     "title" => "${file.name}",
  #     "description" => "${file.name} description",
  #     "category" => "People & Blogs",
  #     "keywords" => "Ideas, Melbourne, Australia, Conversation, The Wheeler Centre, Victoria, Writing",
  #     "visibility" => "private"
  #   }
  # }

  # config.transloadit_auth_key = ENV["TRANSLOADIT_AUTH_KEY"]
  # config.transloadit_auth_secret = ENV["TRANSLOADIT_AUTH_SECRET"]
  # config.transloadit_template_id  = ENV["TRANSLOADIT_TEMPLATE_ID"]
end
