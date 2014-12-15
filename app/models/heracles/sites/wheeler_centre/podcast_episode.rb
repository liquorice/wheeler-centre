module Heracles
  module Sites
    module WheelerCentre
      class PodcastEpisode < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :description, type: :content},
              # - Video (media)
              # - Audio (media)
              {name: :events, type: :associated_pages, page_type: :event},
              {name: :publish_date, type: :date_time, label: "Publish date"},
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
