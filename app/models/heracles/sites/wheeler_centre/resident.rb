module Heracles
  module Sites
    module WheelerCentre
      class Resident < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :description, type: :content},
              {name: :logo, type: :asset, asset_file_type: :image},
            ]
          }
        end
      end
    end
  end
end