module Heracles
  module Sites
    module WheelerCentre
      class Event < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Shortened title"},
              {name: :body, type: :content},
              {name: :start_date, type: :date_time, label: "Event start date"},
              {name: :end_date, type: :date_time, label: "Event end date"},
              {name: :is_all_day, type: :boolean, label: "All day event?"},
              {name: :bookings_open, type: :date_time, label: "Bookings open on"},
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :presenters, type: :associated_pages, page_type: :person},
              {name: :series, type: :associated_pages, page_type: :event_series},
              {name: :recordings, type: :associated_pages, page_type: :recording},
              {name: :life_stage, type: :text, label: "Life stage"},
              {name: :ticketing_stage, type: :text, label: "Ticketing stage"},

              #dates/venues/tickets
              # Presenters
              # Series/programme
              # Recordings
              # Podcasts
              # Lifestage
              # Ticketing stage
              # Promo text
              # External bookings
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

        end
      end
    end
  end
end
