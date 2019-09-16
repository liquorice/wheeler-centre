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
          # n+1 (had to code this quick :grimace:)
          site.pages.of_type(:broadside_speaker_page).sort_by do |bsp|
            bsp.person.fields[:first_name].value
          end.reject do |bsp|
            ["Evelyn Araluen", "An Dang", "Denise Chapman", "Amrita Hepi", "Karen Pickering", "Reni Louise-Permadi", "Eloise Grills", "Claire G. Coleman"].
              include? bsp.title
          end
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
