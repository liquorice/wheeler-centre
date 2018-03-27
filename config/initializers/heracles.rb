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

  config.transloadit_assembly_steps = {
    "original" => {
      "robot" => "/s3/store",
      "use" => "asset",
      "credentials" => "wheeler_centre_heracles"
    },
    "content_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 300,
      "height" => 300,
      "quality" => 75,
      "resize_strategy" => "fillcrop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_thumbnail_resized"]
    },
    "content_small_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 480,
      "height" => 720,
      "quality" => 75,
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_small" => {
      "robot" => "/image/optimize",
      "use" => ["content_small_resized"]
    },
    "content_medium_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 960,
      "height" => 960,
      "quality" => 75,
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_medium" => {
      "robot" => "/image/optimize",
      "use" => ["content_medium_resized"]
    },
    "content_large_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 1400,
      "height" => 1400,
      "quality" => 75,
      "zoom" => false,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_large" => {
      "robot" => "/image/optimize",
      "use" => ["content_large_resized"]
    },
    "content_large_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 1400,
      "height" => 800,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_large_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_large_thumbnail_resized"]
    },
    "content_medium_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 960,
      "height" => 550,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_medium_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_medium_thumbnail_resized"]
    },
    "content_small_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 480,
      "height" => 274,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "content_small_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_small_thumbnail_resized"]
    },
    "itunes_resized" => {
      "robot" => "/image/resize",
      "use" => "asset",
      "width" => 1400,
      "height" => 1400,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true,
      "background" => "none",
      "colorspace" => "RGB"
    },
    "itunes" => {
      "robot" => "/image/optimize",
      "use" => ["itunes_resized"]
    },
    "audio_mp3" => {
      "robot" => "/audio/encode",
      "use" => "asset",
      "preset" => "mp3"
    },
    "audio_ogg" => {
      "robot" => "/audio/encode",
      "use" => "asset",
      "preset" => "ogg"
    },
    "video_ipad_high" => {
      "robot" => "/video/encode",
      "use" => "asset",
      "ffmpeg_stack" => "v2.2.3",
      "preset" => "ipad-high"
    },
    "video_iphone_high" => {
      "robot" => "/video/encode",
      "use" => "asset",
      "ffmpeg_stack" => "v2.2.3",
      "preset" => "iphone-high"
    },
    "store_youtube" => {
      "robot" => "/youtube/store",
      "use" => ["asset"],
      "credentials" => "youtube_auth_1479859234",
      "title" => "${file.name}",
      "description" => "${file.name} description",
      "category" => "People & Blogs",
      "keywords" => "Ideas, Melbourne, Australia, Conversation, The Wheeler Centre, Victoria, Writing",
      "visibility" => "private"
    }
  }
end
