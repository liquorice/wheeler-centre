module Heracles
  module Sites
    module WheelerCentre
      class Blog < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :highlighted_authors_title, type: :text},
              {name: :highlighted_authors_intro, type: :content, with_buttons: %i(bold italic link), disable_insertables: true},
              {name: :highlighted_authors, type: :associated_pages, page_type: :person},
              {name: :middle, type: :content, hint: "Sits between 'Latest' and 'Guest posts'"},
              {name: :end, type: :content, hint: "Sits after 'Guest posts'"},
            ]
          }
        end

        def posts(options={})
          search_posts(options)
        end

        private

        def search_posts(options={})
          Sunspot.search(BlogPost) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :created_at, :desc

            paginate page: options[:page] || 1, per_page: options[:per_page] || 6
          end
        end
      end
    end
  end
end
