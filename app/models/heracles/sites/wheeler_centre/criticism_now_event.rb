module Heracles
  module Sites
    module WheelerCentre
      class CriticismNowEvent < ::Heracles::Page
        def self.config
          {
            fields: [
              # Image
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Accessors

        def reviews
          children.of_type("review")
        end

        def responses
          children.of_type("response")
        end

      end
    end
  end
end
