module Heracles
  module Sites
    module WheelerCentre
      class BlogPost < Heracles::Page

        def self.config
          {
            fields: [
              # Image
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :thumbnail_image, type: :asset, asset_file_type: :image, hint: "Set this to override the above hero image in listings"},
              # Content
              {name: :content_info, type: :info, text: "<hr/>"},
              {name: :summary, type: :content},
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, label: "Content", type: :content, hint: "Main body content"},
              {name: :meta, type: :content, hint: "Additional information about this post. Shows after the body."},
              # Author
              {name: :author_info, type: :info, text: "<hr/>"},
              {name: :guest_post, type: :boolean, question_text: "Is this a guest post?"},
              {name: :authors, type: :associated_pages, page_type: :person},
              # Extra
              {name: :extra_info, type: :info, text: "<hr/>"},
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            authors: fields[:authors].pages.map(&:title).join(", "),
            published: (published) ? "✔" : "•",
            publish_date: fields[:publish_date],
            created_at:  created_at.to_s(:admin_date)
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

          string :author_ids, multiple: true do
            fields[:authors].pages.map(&:id)
          end

          string :author_titles, multiple: true do
            fields[:authors].pages.map(&:title)
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

          string :topic_titles, multiple: true do
            fields[:topics].pages.map(&:title)
          end

          string :tag_list, multiple: true do
            tags.map(&:name)
          end

        end

      end
    end
  end
end
