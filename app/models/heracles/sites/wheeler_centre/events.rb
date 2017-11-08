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
              # Content for off season when there are no events published
              {name: :off_season_info, type: :info, text: "<hr/>"},
              {name: :body_off_season, type: :content, hint: "This content will display when there are no upcoming events."},
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
          Event.where(
            site_id: site.id,
            hidden: false,
            published: true
          )
          .children_of(self)
          .where("fields_data->'start_date'->>'value' >= ? ", Time.zone.now.beginning_of_day)
          .order("fields_data->'start_date'->>'value' ASC")
          .page(options[:page] || 1)
          .per(options[:per_page] || 1000)

          # Sunspot.search(Event) do
          #   # with :site_id, site.id
          #   # with :parent_id, id
          #   # with :published, true
          #   # with :hidden, false
          #   with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)

          #   order_by :start_date_time, :asc
          #   paginate(page: options[:page] || 1, per_page: options[:per_page] || 1000)
          # end
        end

        def search_events(options={})
          Event.where(
            site_id: site.id,
            published: true,
            hidden: false
          )
          .children_of(self)
          .where("fields_data->'start_date'->>'value' >= ? ", Time.zone.now.beginning_of_day)
          .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
          .page(options[:page] || 1)
          .per(options[:per_page] || 1000)

          # Sunspot.search(Event) do
          #   with :site_id, site.id
          #   with :parent_id, id
          #   with :published, true
          #   with :hidden, false

          #   order_by :start_date_time, :desc
          #   paginate(page: options[:page] || 1, per_page: options[:per_page] || 50)
          # end
        end
      end
    end
  end
end
