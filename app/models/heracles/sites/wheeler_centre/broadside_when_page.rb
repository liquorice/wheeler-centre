module Heracles
  module Sites
    module WheelerCentre
      class BroadsideWhenPage < ::Heracles::Page
        def self.config
          {
            fields: [
            ]
          }
        end

        def saturday_event_pages
          event_pages_grouped_by_day["Sat"]
        end

        def sunday_event_pages
          event_pages_grouped_by_day["Sun"]
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end

        def broadside_events
          broadside_series = Heracles::Page.of_type(:event_series).find_by(title: "Broadside")
          Heracles::Page.of_type(:event).where("(fields_data#>'{series, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: broadside_series.id).order("fields_data->'start_date'->>'value' ASC NULLS LAST")
        end

        private

        def event_pages
          # This is done this way so we get the event_pages in date order of the associated event... N+1; probably a better way of doing this.
          broadside_events.map do |event|
            site.pages.of_type(:broadside_event_page).where("(fields_data#>'{event, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: [event.id]).first
          end
        end

        def event_pages_grouped_by_day
          event_pages.group_by do |event_page|
            event_page.event.fields[:start_date].value.strftime("%a")
          end
        end
      end
    end
  end
end
