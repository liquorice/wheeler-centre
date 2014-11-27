module Heracles
  module Sites
    module WheelerCentre
      class Person < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
              {name: :hero_image, type: :asset, asset_file_type: :image},
            ]
          }
        end

        def allowed_child_page_classes
          []
        end
      end
    end
  end
end
