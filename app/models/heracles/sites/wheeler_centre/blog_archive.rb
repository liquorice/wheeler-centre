module Heracles
  module Sites
    module WheelerCentre
      class BlogArchive < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :nav_title, type: :text},
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def posts(options={})
          search_posts(options)
        end

        private

        def blog_index
          parent
        end

        def search_posts(options={})
          Sunspot.search(BlogPost) do
            with :site_id, site.id
            with :parent_id, blog_index.id
            with :published, true
            with :hidden, false

            order_by :created_at, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 36)
          end
        end
      end
    end
  end
end
