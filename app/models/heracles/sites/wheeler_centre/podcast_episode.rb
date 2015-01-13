module Heracles
  module Sites
    module WheelerCentre
      class PodcastEpisode < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :description, type: :content},
              {name: :video, type: :asset, asset_file_type: :video},
              {name: :audio, type: :asset, asset_file_type: :audio},
              {name: :events, type: :associated_pages, page_type: :event},
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        searchable do
          text :description do
            fields[:description].value
          end

          date :publish_date do
            fields[:publish_date].value
          end
        end
      end
    end
  end
end
