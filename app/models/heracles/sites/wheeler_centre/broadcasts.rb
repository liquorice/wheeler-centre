module Heracles
  module Sites
    module WheelerCentre
      class Broadcasts < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        ### Accessors

        def recordings(options={})
          search_recordings(options)
        end

        private

        def search_recordings(options={})
          Sunspot.search(Recording) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :start_date_time, :asc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 18)
          end
        end
      end
    end
  end
end
