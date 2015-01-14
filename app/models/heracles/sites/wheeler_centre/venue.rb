module Heracles
  module Sites
    module WheelerCentre
      class Venue < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :address, type: :text},
              {name: :address_formatted, type: :content},
              {name: :phone_number, type: :text},
              {name: :description, type: :content},
              {name: :directions, type: :content},
              {name: :parking, type: :content},
            ]
          }
        end
      end
    end
  end
end
