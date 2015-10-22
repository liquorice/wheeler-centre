require "heracles/content_field_rendering/assets_filter"

module Heracles
  module Sites
    module WheelerCentre
      class AssetsFilter < Heracles::ContentFieldRendering::AssetsFilter
        include Rails.application.routes.url_helpers
        include ::TrackingHelper

        def call
          html_doc.css("[data-asset-id]").each do |link_node|
            asset_id = link_node["data-asset-id"]
            asset = find_asset(asset_id)
            if asset
              asset_version = asset.has_version?(:asset_link_version) ? :asset_link_version : :original

              link_node["href"] = track_event(
                asset.results[asset_version]["url"],
                {
                  title: (asset.title.blank?) ? asset.file_name : asset.title,
                  event_category: "asset",
                  event_action: "download"
                }
              )
              link_node.remove_attribute("data-asset-id")
            else
              link_node["data-error"] = "Asset not found"
              delinkify!(link_node)
            end
          end
          html_doc
        end
      end
    end
  end
end
