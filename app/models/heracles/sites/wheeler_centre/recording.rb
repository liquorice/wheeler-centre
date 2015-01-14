module Heracles
  module Sites
    module WheelerCentre
      class Recording < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title"},
              {name: :description, type: :content},
              {name: :transcripts, type: :content},
              {name: :video, type: :asset, asset_file_type: :video},
              {name: :audio, type: :asset, asset_file_type: :audio},
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :events, type: :associated_pages, page_type: :event},
              # Dates
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :recording_date, type: :date_time, label: "Recording date"},
              {name: :recording_id, type: :integer, label: "Recording Id"},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          text :description do
            fields[:description].value
          end

          text :transcripts do
            fields[:transcripts].value
          end

          date :publish_date do
            fields[:publish_date].value
          end

          date :recording_date do
            fields[:recording_date].value
          end

          string :event_ids, multiple: true do
            fields[:events].pages.map(&:id)
          end

        end
      end
    end
  end
end
