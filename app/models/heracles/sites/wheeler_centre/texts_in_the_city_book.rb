module Heracles
  module Sites
    module WheelerCentre
      class TextsInTheCityBook < Heracles::Page

        def self.config
          {
            fields: [
              {name: :cover_image, type: :assets, assets_file_type: :image},
              {name: :body, type: :content},
              {name: :further_reading, type: :content},
              {name: :author, type: :text},
              {name: :author_biography, type: :content},
            ]
          }
        end

        searchable do
          text :body do
            fields[:body].value
          end
        end
      end
    end
  end
end
