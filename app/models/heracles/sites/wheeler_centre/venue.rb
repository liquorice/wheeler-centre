module Heracles
  module Sites
    module WheelerCentre
      class Venue < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :address, type: :text, hint: "Not displayed on site, used for address lookups on Google Maps"},
              {name: :address_formatted, type: :content, hint: "Nicely formatted for display on the site"},
              {name: :phone_number, type: :text},
              {name: :description, type: :content},
              {name: :directions, type: :content},
              {name: :parking, type: :content},
              {name: :legacy_venue_id, type: :text, label: "Legacy Venue ID"},
            ]
          }
        end


        ### Accessors

        def map_data
          {
            title: title,
            address: fields[:address].value,
            address_formatted: fields[:address_formatted].value
          }.to_json
        end

        ### Searchable

        searchable do
          text :title do
            title
          end
        end

      end
    end
  end
end
