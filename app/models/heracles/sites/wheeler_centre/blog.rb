module Heracles
  module Sites
    module WheelerCentre
      class Blog < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content}
            ]
          }
        end

        def posts(options={})
          search_posts(options)
        end

        def guest_authors(options={})
          search_guest_authors(options)
        end

        private

        def search_posts(options={})
          Sunspot.search(BlogPost) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :created_at, :desc

            paginate page: options[:page] || 1, per_page: options[:per_page] || 20
          end
        end

        # TODO this only returns a random 5 authors
        def search_guest_authors(options={})
          Sunspot.search(Person) do
            with :site_id, site.id
            with :published, true

            order_by :updated_at, :desc

            paginate page: options[:page] || 1, per_page: options[:per_page] || 4
          end
        end
      end
    end
  end
end
