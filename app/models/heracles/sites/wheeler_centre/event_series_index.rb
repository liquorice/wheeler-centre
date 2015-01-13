module Heracles
  module Sites
    module WheelerCentre
      class EventSeriesIndex < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def event_series
          search_event_series
        end

        private

        def search_event_series
          Sunspot.search(EventSeries) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :start_date_time, :asc
            paginate(page: 1, per_page: 1000)
          end
        end
      end
    end
  end
end
