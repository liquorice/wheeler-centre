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

        def nav_pages
          if parent.url == "broadside"
            [self] + children.published.visible.rank(:page_order)
          else
            siblings.published.visible.rank(:page_order)
          end
        end
      end
    end
  end
end
