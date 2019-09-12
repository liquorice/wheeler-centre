module Heracles
  module Sites
    module WheelerCentre
      class BroadsideContentPage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :alternative_title, type: :text},
              {name: :body, type: :content},
            ]
          }
        end

        def page_title
          if parent != site.pages.of_type(:broadside_home_page).all.first
            parent.title
          else
            title
          end
        end

        def nav_pages
          if parent.url == "broadside"
            [self] + children.published.visible.rank(:page_order)
          else
            [parent] + siblings.published.visible.rank(:page_order)
          end
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
