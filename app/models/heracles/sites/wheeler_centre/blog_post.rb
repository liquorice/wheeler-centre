module Heracles
  module Sites
    module WheelerCentre
      class BlogPost < Heracles::Page

        def self.config
          {
            fields: [
              {name: :summary, type: :content},
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, label: "Content", type: :content, hint: "Main body content"},
              {name: :meta, type: :content, hint: "Additional information about this post. Shows after the body."},
              {name: :hero_image, type: :asset, asset_file_type: :image},
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
