module Heracles
  module Sites
    module WheelerCentre
      class LongformBlogEdition < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :assets, assets_file_type: :image},
              {name: :summary, type: :content},
              {name: :body, type: :content},
              {name: :highlight_colour, type: :text, editor_type: 'code'},
              {name: :interview, type: :content},
              {name: :editorial, type: :content, hint: ""},
              {name: :quotes, type: :content, hint: ""},
            ]
          }
        end

        def posts(options={})
          search_posts(options)
        end

        private

        def search_posts(options={})
          # LongformBlogPost.where(
          #   site_id: site.id,
          #   published: true,
          #   hidden: false
          # )
          # .children_of(LongformBlog.find(id))
          # .order("fields_data->'publish_date'->>'value' DESC NULLS LAST")
          # .page(options[:page] || 1)
          # .per(options[:per_page] || 6)

          Heracles::Page.
            of_type("longform_blog_post").
            visible.
            published.
            where.not(
              id: options[:exclude]
            ).
            joins(:insertions).
            where(
              :"insertions.field" => "edition",
              :"insertions.inserted_key" => insertion_key
            ).
            page(options[:page_number] || 1).
            per(options[:per_page] || 1000)
        end
      end
    end
  end
end
