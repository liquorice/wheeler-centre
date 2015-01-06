module Heracles
  module Sites
    module WheelerCentre
      class PodcastSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :feature_image, type: :asset, asset_file_type: :image},
              {name: :description, type: :content},
              {name: :itunes_categories, type: :array},
              {name: :episodes, type: :associated_pages, page_type: :podcast},
            ]
          }
        end

        searchable do
          text :description do
            fields[:description].value
          end
        end
      end
    end
  end
end
