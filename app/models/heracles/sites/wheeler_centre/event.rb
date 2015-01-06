module Heracles
  module Sites
    module WheelerCentre
      class Event < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title"},
              {name: :body, type: :content},
              # Dates
              {name: :start_date, type: :date_time, label: "Event start date"},
              {name: :end_date, type: :date_time, label: "Event end date"},
              {name: :display_date, type: :text, hint: "Specify this if you want to customise the display of the date/time"},
              # Venues
              {name: :venue, type: :text, label: "Venue"},
              # Bookings
              {name: :bookings_open_at, type: :date_time, label: "Bookings open on"},
              {name: :external_bookings, type: :text, label: "External bookings"},
              # Other
              {name: :promo_image, type: :asset, asset_file_type: :image},
              {name: :presenters, type: :associated_pages, page_type: :person},
              {name: :series, type: :associated_pages, page_type: :event_series},
              {name: :recordings, type: :associated_pages, page_type: :recording},
              {name: :podcasts, type: :associated_pages, page_type: :podcast},
              {name: :life_stage, type: :text, label: "Life stage"},
              {name: :ticketing_stage, type: :text, label: "Ticketing stage"},
              {name: :promo_text, type: :text, label: "Promotion text"},
              {name: :sponsors, type: :associated_pages, page_type: :sponsor},
            ]
          }
        end

        searchable do
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
