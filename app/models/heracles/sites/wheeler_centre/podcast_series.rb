module Heracles
  module Sites
    module WheelerCentre
      class PodcastSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :feature_image, type: :asset, asset_file_type: :image},
              {name: :description, type: :content},
              # - iTunes categories (list)
              # - Podcast Episodes (collection)
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
