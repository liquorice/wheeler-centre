module Heracles
  class ImageInsertableRenderer < InsertableRenderer
    include Heracles::CloudinaryAssetHelper
    include Heracles::TransloaditAssetHelper

    ### Custom renderer

    def render
      # Return nothing if the asset is missing
      return "" unless asset

      super
    end

    ### Helpers

    helper_method \
    def asset
      find_asset data[:asset_id]
    end

    helper_method \
    def asset_url
      if (asset_processor_name = options[:asset_processor])
        send(:"#{asset_processor_name}_asset_url", asset, options[:asset_processor_options] || {})
      else
        asset.original_url
      end
    end

    helper_method \
    def wrapper_div_class
      aspect_class = if asset.aspect_ratio && asset.aspect_ratio < 1.333333
        "figure__image--portrait"
      else
        "figure__image--landscape"
      end

      [
        "figure",
        "figure__display--#{(data[:display].presence || "default").downcase}",
        aspect_class
      ].join(" ")
    end

    helper_method \
    def wrapper_div_style
      "width:#{data[:width]}" if data[:width].present?
    end

    helper_method \
    def alt_text
      data[:alt_text].presence || asset.description
    end

    helper_method \
    def link_url
      link = data[:link]
      if link.present?
        if link[:href].present?
          url = link[:href]
        elsif link[:pageID].present?
          page = find_page link[:pageID]
          url = page.absolute_url
        elsif link[:assetID].present?
          linked_asset = find_asset(link[:assetID])
          if linked_asset
            url = linked_asset.original_url
          end
        end
        url
      end
    end

    helper_method \
    def link_title
      link = data[:link]
      if link.present?
        data[:link][:title].presence
      end
    end

    helper_method \
    def link_target
      link = data[:link]
      if link.present?
        data[:link][:target].presence
      end
    end

    private

    def find_page(page_id)
      site.pages.find_by_id(page_id) if page_id.present?
    end

    def find_asset(asset_id)
      site.assets.find_by_id(asset_id) if asset_id.present?
    end
  end
end
