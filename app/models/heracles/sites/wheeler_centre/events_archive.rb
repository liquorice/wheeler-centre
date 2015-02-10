module Heracles
  module Sites
    module WheelerCentre
      class EventsArchive < ::Heracles::Page
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
            with(:start_date_time).less_than(Time.zone.now.beginning_of_day)
            without :start_date_time, nil

            order_by :start_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 36)
          end
        end
      end
    end
  end
end
