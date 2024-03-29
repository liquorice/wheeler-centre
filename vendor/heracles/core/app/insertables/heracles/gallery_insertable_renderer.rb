module Heracles
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
