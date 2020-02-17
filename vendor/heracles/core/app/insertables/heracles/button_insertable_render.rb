module Heracles
  class ButtonInsertableRenderer < InsertableRenderer
    ### Custom renderer

    ### Helpers
    helper_method \
    def button_text
      data[:text]
    end

    helper_method \
    def button_classes
      "btn" + position_class + size_class + color_class
    end

    helper_method \
    def button_url
      link = data[:link]
      if link.present?
        if link[:href].present?
          url = link[:href]
        elsif link[:pageID].present?
          page = find_page link[:pageID]
          url = page.absolute_url
        elsif link[:assetID].present?
          asset = find_asset link[:assetID]
          asset_version = asset.has_version?(:asset_link_version) ? :asset_link_version : :original
          url = asset.results[asset_version]["url"]
        end
        url
      end
    end

    helper_method \
    def is_positioned_center
      data[:position] == "Center"
    end

    private

    def position_class()
      if data[:position] == "Default" \
        then "" \
      else " btn--#{(data[:position] || "").downcase}" end
    end

    def size_class()
      if data[:size] == "Default" \
        then "" \
        else " btn--#{(data[:size] || "").downcase}" end
    end

    def color_class()
      if data[:color] == "Default" \
        then "" \
        else " btn--#{(data[:color] || "").downcase}" end
    end

    def find_page(page_id)
      site.pages.find_by_id(page_id) if page_id.present?
    end

    def find_asset(asset_id)
      site.assets.find_by_id(asset_id) if asset_id.present?
    end
  end
end
