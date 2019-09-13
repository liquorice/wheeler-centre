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
          # n+1
          site.pages.of_type(:broadside_speaker_page).sort_by do |bsp|
            bsp.person.fields[:last_name].value
          end
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
