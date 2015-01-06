module Heracles
  module Sites
    module WheelerCentre
      class BookReview < Heracles::Page

        def self.config
          {
            fields: [
              {name: :summary, type: :content},
              {name: :body, label: "Content", type: :content, hint: "Main body content"},
              {name: :further_reading, type: :content},
              {name: :book_awards_books, label: "Book awards book", type: :associated_pages, page_type: :book},
              {name: :reviewers, label: "Reviewer", type: :associated_pages, page_type: :person},
            ]
          }
        end

        searchable do
          text :summary do
            fields[:summary].value
          end

          text :body do
            fields[:body].value
          end

          text :further_reading do
            fields[:further_reading].value
          end

          string :book_awards_book_ids, multiple: true do
            fields[:book_awards_books].pages.map(&:id)
          end

          string :reviewers, multiple: true do
            fields[:books].pages.map(&:id)
          end
        end

      end
    end
  end
end