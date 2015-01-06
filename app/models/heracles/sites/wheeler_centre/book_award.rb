module Heracles
  module Sites
    module WheelerCentre
      class BookAward < Heracles::Page

        def self.config
          {
            fields: [
              {name: :body, label: "Content", type: :content, hint: "Main body content"},
              {name: :categories, type: :array},
              {name: :year, type: :integer},
              {name: :banner_image, type: :asset, asset_file_type: :image},
              {name: :books, type: :associated_pages, page_type: :book},
              # TODO Votes
              # TODO For nominated books
              # TODO For write in nominations
            ]
          }
        end

        searchable do
          text :body do
            fields[:body].value
          end

          string :book_ids, multiple: true do
            fields[:books].pages.map(&:id)
          end

        end

      end
    end
  end
end
