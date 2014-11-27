module Heracles
  module Sites
    module WheelerCentre
      class Event < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :start_date, type: :date_time, label: "Event start date"},
              {name: :end_date, type: :date_time, label: "Event end date"},
              {name: :display_date, type: :text, hint: "Specify this if you want to customise the display of the date/time"},
              {name: :body, type: :content},
              {name: :hero_image, type: :asset, asset_file_type: :image},
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
