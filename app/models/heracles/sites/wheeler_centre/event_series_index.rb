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

        ### Accessors

        def event_series(options={})
          search_event_series(options)
        end

        def active_series(options={})
          options.reverse_merge!({active: true})
          search_event_series(options)
        end

        private

        def search_event_series(options={})
          Sunspot.search(EventSeries) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            if options[:active] == true
              with :archived, false
              without :event_ids, nil
            end

            order_by :created_at, :asc
            paginate(page: 1, per_page: 1000)
          end
        end
      end
    end
  end
end
