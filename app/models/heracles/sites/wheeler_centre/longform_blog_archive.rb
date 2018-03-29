module Heracles
  module Sites
    module WheelerCentre
      class LongformBlogArchive < ::Heracles::Page
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

        def longform_blog_index
          parent
        end

        def search_posts(options={})
          LongformBlogPost.where(
            site_id: site.id,
            published: true,
            hidden: false
          )
          .children_of(LongformBlog.find(longform_blog_index.id))
          .order(created_at: :desc)
          .page(options[:page] || 1)
          .per(options[:per_page] || 36)
        end
      end
    end
  end
end
