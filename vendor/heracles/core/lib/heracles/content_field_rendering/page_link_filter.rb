module Heracles
  module ContentFieldRendering
    class PageLinkFilter < Filter
      def call
        html_doc.css("[data-page-id]").each do |link_node|
          page_id = link_node["data-page-id"]
          page = find_page(page_id)
          if page
            link_node["href"] = page.absolute_url
            link_node.remove_attribute("data-page-id")
          else
            link_node["data-error"] = "Page not found"
            delinkify!(link_node)
          end
        end
        html_doc
      end

      private

      def find_page(page_id)
        site.pages.find_by_id(page_id) if page_id.present?
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
