module Heracles
  module ContentFieldRendering
    class AssetsFilter < Filter
      def call
        html_doc.css("[data-asset-id]").each do |link_node|
          asset_id = link_node["data-asset-id"]
          asset = find_asset(asset_id)
          if asset
            link_node["href"] = asset.original_url
            link_node.remove_attribute("data-asset-id")
          else
            link_node["data-error"] = "Asset not found"
            delinkify!(link_node)
          end
        end
        html_doc
      end

      private

      def find_asset(asset_id)
        site.assets.find_by_id(asset_id) if asset_id.present?
      end

      def delinkify!(node)
        node.name = "span"
        node.remove_attribute("data-page-id")
        node.remove_attribute("href")
        node.remove_attribute("target")
        node.remove_attribute("title")
      end
    end
  end
end
