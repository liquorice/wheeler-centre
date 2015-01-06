module Heracles
  module Sites
    module WheelerCentre
      class Book < Heracles::Page

        def self.config
          {
            fields: [
              {name: :publisher, type: :text},
              {name: :publication_date, type: :date_time, label: "Date of publication"},
              {name: :category, type: :text},
              {name: :blurb, label: "Blurb", type: :content},
              {name: :cover_image, type: :asset, asset_file_type: :image},
              {name: :author, type: :associated_pages, page_type: :author},
              {name: :videos, type: :content},
              {name: :links, type: :content},
              {name: :reviews, type: :associated_pages, page_type: :book_review},
            ]
          }
        end

        searchable do
          text :blurb do
            fields[:blurb].value
          end
        end

      end
    end
  end
end
