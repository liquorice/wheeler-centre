module Heracles
  module Sites
    module WheelerCentre
      class GalleryInsertableRenderer < InsertableRenderer
        include Heracles::CloudinaryAssetHelper
        include Heracles::TransloaditAssetHelper


        ### Helpers

        helper_method \
        def assets
          find_assets
        end

        helper_method \
        def wrapper_div_class
          [
            "gallery-container",
            "gallery-container--#{(data[:display].presence || "default").downcase}"
          ].join(" ")
        end

        helper_method \
        def wrapper_div_style
          "width:#{data[:width]}" if data[:width].present?
        end

        helper_method \
        def gallery_slide_data
          assets.each_with_index.map {|asset, i|
            version_name = :content_large
            {
              image: asset.send(:"#{version_name.to_sym}_url"),
              caption: (data[:assets_data][i][:caption] if data[:assets_data][i][:caption].present?),
              attribution: (asset.attribution if asset.attribution.present? && data[:assets_data][i][:show_attribution] == true)
            }
          }
        end

        helper_method \
        def images
          assets.each_with_index.map {|asset, i|
            asset_data = data[:assets_data][i]
            thumbnail_version_name = :content_thumbnail
            large_version_name = :content_large
            {
              thumbnail_url: asset.send(:"#{thumbnail_version_name.to_sym}_url"),
              alt_text: asset_data[:alt_text],
              link_url: asset_data[:link].present? ? asset_data[:link] : asset.send(:"#{large_version_name.to_sym}_url")
            }
          }
        end

        private

        def asset_ids
          ids = @data[:assets_data].map { |data| data[:asset_id] } if @data[:assets_data].present?
          Array.wrap(ids)
        end

        def assets_order_sql
          sql = "CASE assets.id "
          asset_ids.each_with_index do |id, position|
            sql += "WHEN '#{id}' THEN #{position} "
          end
          sql += "END"
          sql
        end

        def find_assets
          return Heracles::Asset.none if asset_ids.blank?

          # Respect the order of the assets as specified in IDs list
          Heracles::Asset.where(id: asset_ids).reorder(assets_order_sql)
        end
      end
    end
  end
end

