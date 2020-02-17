module Heracles
  module TransloaditAssetHelper
    class AssetVersionMissing < StandardError; end

    extend AssetsHelper.presenter_macros_for_processor(:transloadit)

    present_processed_asset def transloadit_asset_url(asset, version, options={})
      use_ssl = options.fetch(:ssl, site.configuration.use_ssl_for_asset_urls)

      if asset.has_version?(version)
        asset.version(version).send(use_ssl ? :ssl_url : :url)
      else
        raise AssetVersionMissing, "Version '#{version}' not found for this asset"
      end
    end

    present_processed_asset def transloadit_asset_image_tag(asset, version, options={})
      url = transloadit_asset_url(asset, version, options)
      image_tag(url, options)
    end

    def transloadit_asset_admin_thumbnail_url(asset)
      transloadit_asset_url(asset, TransloaditAssetProcessor::ADMIN_THUMBNAIL_VERSION)
    rescue AssetVersionMissing
      fallback_transloadit_asset_admin_thumbnail_url(asset)
    end

    def transloadit_asset_admin_preview_url(asset)
      transloadit_asset_url(asset, TransloaditAssetProcessor::ADMIN_PREVIEW_VERSION)
    rescue AssetVersionMissing
      fallback_transloadit_asset_admin_preview_url(asset)
    end

    def transloadit_asset_admin_thumbnail_image_tag(asset, options={})
      transloadit_asset_image_tag(asset, TransloaditAssetProcessor::ADMIN_THUMBNAIL_VERSION, options)
    end

    def transloadit_asset_admin_preview_image_tag(asset, options={})
      transloadit_asset_image_tag(asset, TransloaditAssetProcessor::ADMIN_PREVIEW_VERSION, options)
    end

    private

    def fallback_transloadit_asset_admin_thumbnail_url(asset)
      fallback_asset_admin_thumbnail_url(asset)
    end

    def fallback_transloadit_asset_admin_preview_url(asset)
      asset.original_url
    end
  end
end
