module Heracles
  module Sites
    module WheelerCentre
      class CriticismNowEvent < ::Heracles::Page
        def self.config
          {
            fields: [
              # Image
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :body, type: :content},
              # Listen
              {name: :listen, type: :content},
              {name: :watch, type: :content},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Accessors

        def reviews
          children.published.of_type("review")
        end

        def responses
          children.published.of_type("response")
        end

      end
    end
  end
end
