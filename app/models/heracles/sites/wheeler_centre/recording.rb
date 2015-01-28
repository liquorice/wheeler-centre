module Heracles
  module Sites
    module WheelerCentre
      class Recording < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title"},
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :description, type: :content},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :recording_date, type: :date_time, label: "Recording date"},
              # Asset
              {name: :asset_info, type: :info, text: "<hr/>"},
              {name: :video, type: :asset, asset_file_type: :video},
              {name: :audio, type: :asset, asset_file_type: :audio},
              # Associations
              {name: :assoc_info, type: :info, text: "<hr/>"},
              {name: :events, type: :associated_pages, page_type: :event},
              {name: :people, type: :associated_pages, page_type: :person},
              # Extra
              {name: :extra_info, type: :info, text: "<hr/>"},
              {name: :topics, type: :associated_pages, page_type: :topic},
              {name: :recording_id, type: :integer, label: "Legacy recording ID"},
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
