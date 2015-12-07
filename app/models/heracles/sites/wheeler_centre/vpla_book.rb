module Heracles
  module Sites
    module WheelerCentre
      class VplaBook < Heracles::Page

        def self.config
          {
            fields: [
              {name: :publisher, type: :text},
              {name: :publication_date, type: :text, label: "Date of publication"},
              {name: :category, type: :associated_pages, page_type: :vpla_category, hint: "Be careful, you need to select the category from the correct year!", editor_type: :singular},
              {name: :blurb, type: :content},
              {name: :cover_image, type: :asset, asset_file_type: :image},
              # Author
              {name: :author, type: :text},
              {name: :author_image, type: :asset, asset_file_type: :image},
              {name: :author_image_credit, type: :text},
              {name: :author_biography, type: :content},
              # Media
              {name: :videos, type: :content},
              {name: :links, type: :content},
              # Reviews
              {name: :review, type: :content},
              {name: :reviewer, type: :text},
              {name: :library, type: :text},
              {name: :library_website, type: :text},
              # Judges report
              {name: :judges_report, type: :content, label: "Judge’s report"},
              {name: :sort_name, type: :text},
            ]
          }
        end

        def year
          parent
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
