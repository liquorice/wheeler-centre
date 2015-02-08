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
              # Even series intro
              {name: :event_series_info, type: :info, text: "<hr/>"},
              {name: :event_series_intro, type: :content, hint: "A line or two to introduce the current event series"},
            ]
          }
        end

        ### Accessors

        # Return _all_ the upcoming events
        def upcoming_events(options={})
          search_upcoming_events(options)
        end

        def events(options={})
          search_events(options)
        end

        def active_series
          children.of_type("event_series_index").first.active_series
        end

        private

        def search_upcoming_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true
            with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)

            order_by :start_date_time, :asc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 1000)
          end
        end

        def search_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :start_date_time, :asc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 50)
          end
        end
      end
    end
  end
end
