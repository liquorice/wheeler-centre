module Heracles
  module Sites
    module WheelerCentre
      class BlogPost < Heracles::Page

        ### Page config

        def self.config
          {
            fields: [
              {name: :summary, type: :content},
              {name: :body, label: "Content", type: :content, hint: "Main body content", editor_columns: 12},
              {name: :hero_image, type: :asset, asset_file_type: :image},
              # Is the author relationship ever going to be many to one?
              {name: :authors, type: :associated_pages, page_type: :person},
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

          string :author_ids, multiple: true do
            fields[:authors].pages.map(&:id)
          end

        end

      end
    end
  end
end
