module Heracles
  module Sites
    module WheelerCentre
      class Blog < Heracles::Page
        def self.config
          {}
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

            without(:publish_at).greater_than_or_equal_to(Time.current)

            order_by :publish_at, :desc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 10
          end
        end
      end
    end
  end
end
