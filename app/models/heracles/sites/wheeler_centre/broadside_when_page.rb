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

        private

        def event_pages
          site.pages.of_type(:broadside_event_page).where.not(title: "Teen Day")
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
