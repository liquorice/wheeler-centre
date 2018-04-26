module Heracles
  module Sites
    module WheelerCentre
      class LongformBlog < Heracles::Page
        def self.config
          {
            fields: [
              {name: :nav_title, type: :text},
              {name: :intro, label: "Introduction", type: :content},
              {name: :featured_editions, type: :associated_pages, page_type: :longform_blog_edition},
              {name: :end, type: :content, hint: "Shown after the edition list"},
            ]
          }
        end

        def editions(options={})
          search_editions(options)
        end

        private

        def search_editions(options={})
          fields[:featured_editions]
            .pages
            .published
            .visible
            .rank(:page_order)
        end
      end
    end
  end
end
