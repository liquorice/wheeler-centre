module Heracles
  module Sites
    module Wheelercentre
      class ContentPage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
              {name: :hero_image, type: :asset, asset_file_type: :image},
            ]
          }
        end
      end
    end
  end
end
