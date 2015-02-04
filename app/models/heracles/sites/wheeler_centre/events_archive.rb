module Heracles
  module Sites
    module WheelerCentre
      class EventsArchive < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def events(options={})
          search_events(options)
        end

        private

        def events_index
          parent
        end

        def search_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :parent_id, events_index.id
            with :published, true

            order_by :start_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 50)
          end
        end
      end
    end
  end
end
