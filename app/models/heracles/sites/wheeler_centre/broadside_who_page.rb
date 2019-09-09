module Heracles
  module Sites
    module WheelerCentre
      class BroadsideWhoPage < ::Heracles::Page
        def self.config
          {
            fields: [
            ]
          }
        end

        def speaker_pages
          site.pages.of_type(:broadside_speaker_page)
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
