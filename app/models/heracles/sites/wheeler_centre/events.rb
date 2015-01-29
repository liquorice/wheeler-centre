module Heracles
  module Sites
    module WheelerCentre
      class Events < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def events
          search_events
        end

        private

        def search_events
          Sunspot.search(Event) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :start_date_time, :asc
            paginate(page: 1, per_page: 50)
          end
        end
      end
    end
  end
end
