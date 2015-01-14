module Heracles
  module Sites
    module WheelerCentre
      class Event < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title"},
              {name: :promo_image, type: :asset, asset_file_type: :image},
              {name: :body, type: :content},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :start_date, type: :date_time, label: "Event start date"},
              {name: :end_date, type: :date_time, label: "Event end date"},
              {name: :display_date, type: :text, hint: "Specify this if you want to customise the display of the date/time"},
              # Venues
              {name: :venue, type: :associated_pages, page_type: :venue, label: "Venue", editor_type: 'singular'},
              # Bookings
              {name: :booking_info, type: :info, text: "<hr/>"},
              {name: :bookings_open_at, type: :date_time, label: "Bookings open on"},
              {name: :external_bookings, type: :text, label: "External bookings"},
              # Other
              {name: :presenters, type: :associated_pages, page_type: :person},
              {name: :series, type: :associated_pages, page_type: :event_series, editor_type: 'singular'},
              {name: :recordings, type: :associated_pages, page_type: :recording, editor_columns: 6},
              {name: :podcasts, type: :associated_pages, page_type: :podcast, editor_columns: 6},
              {name: :life_stage, type: :text, label: "Life stage"},
              {name: :ticketing_stage, type: :text, label: "Ticketing stage"},
              {name: :promo_text, type: :text, label: "Promo text", hint: "2-3 words to highlight event in listings"},
              {name: :sponsors, type: :associated_pages, page_type: :sponsor},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          text :body do
            fields[:body].value
          end

          date :start_date do
            fields[:start_date].value
          end

          time :start_date_time do
            fields[:start_date].value
          end

          date :end_date do
            fields[:end_date].value
          end

          time :end_date_time do
            fields[:end_date].value
          end

          string :event_series_ids, multiple: true do
            fields[:series].pages.map(&:id)
          end

        end
      end
    end
  end
end
