module Heracles
  module Sites
    module WheelerCentre
      class LongformBlogEdition < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_content, type: :content, hint: "Shown on the edition list page — can include image(s)"},
              {name: :hero_image, type: :assets, assets_file_type: :image, hint: "Displayed at the top"},
              {name: :intro, type: :content, hint: "Shown above the notes list"},
              {name: :end, type: :content, hint: "Shown after the notes list"},
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
