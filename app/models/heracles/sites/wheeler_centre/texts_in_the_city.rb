module Heracles
  module Sites
    module WheelerCentre
      class TextsInTheCity < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content}
            ]
          }
        end

        def books
          children.of_type("texts_in_the_city_book").visible.published
        end
      end
    end
  end
end
