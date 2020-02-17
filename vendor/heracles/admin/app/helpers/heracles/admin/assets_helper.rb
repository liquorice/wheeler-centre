module Heracles
  module Admin
    module AssetsHelper
      ADMIN_ASSET_VERSIONS = [:thumbnail, :preview].freeze

      ADMIN_ASSET_VERSIONS.each do |version|
        define_method(:"asset_admin_#{version}_url") do |asset|
          begin
            if primary_asset_processor
              send(:"#{primary_asset_processor.processor_name}_asset_admin_#{version}_url", asset)
            else
              send(:"fallback_asset_admin_#{version}_url", asset)
            end
          rescue ProcessedAssetMissing
            send(:"fallback_asset_admin_#{version}_url", asset)
          end
        end

        define_method(:"asset_admin_#{version}_image_tag") do |asset, options={}|
          begin
            if primary_asset_processor
              send(:"#{primary_asset_processor.processor_name}_asset_admin_thumbnail_image_tag", asset, options)
            else
              image_tag(send(:"fallback_asset_admin_#{version}_url", asset, options), options)
            end
          rescue ProcessedAssetMissing
            image_tag(send(:"fallback_asset_admin_#{version}_url", asset, options), options)
          end
        end
      end

      private

      def primary_asset_processor
        Heracles::AssetProcessor.processors_for_site(site).first
      end

      def fallback_asset_admin_thumbnail_url(asset)
        image_path("heracles/admin/admin-thumbnail-fallback.png")
      end

      def fallback_asset_admin_preview_url(asset)
        asset.original_url
      end
    end
  end
end
