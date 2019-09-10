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
            [self] + children
          else
            siblings
          end
        end
      end
    end
  end
end
