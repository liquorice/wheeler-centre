module Heracles
  module Sites
    module WheelerCentre
      class BroadsideWhenPage < ::Heracles::Page
        def self.config
          {
            fields: [
            ]
          }
        end

        def event_pages
          site.pages.of_type(:broadside_event_page)
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
