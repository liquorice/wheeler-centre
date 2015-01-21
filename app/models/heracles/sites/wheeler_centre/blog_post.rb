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
              {name: :guest_post, type: :boolean, question_text: "Is this a guest post?"},
              {name: :authors, type: :associated_pages, page_type: :person},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Accessors

        def parent_blog
          parent.try(:page_type) == "blog" ? parent : nil
        end

        def guest_post?
          fields[:guest_post].value
        end

        searchable do
          string :id do |page|
            page.id
          end

          text :summary do
            fields[:summary].value
          end
          text :body do
            fields[:body].value
          end

          string :author_ids, multiple: true do
            fields[:authors].pages.map(&:id)
          end

          time :created_at do
            created_at
          end

          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

        end

      end
    end
  end
end
