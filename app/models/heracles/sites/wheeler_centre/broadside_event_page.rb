module Heracles
  module Sites
    module WheelerCentre
      class BroadsideEventPage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :event, type: :associated_pages, page_type: :event, label: "Event", editor_type: 'singular'},
            ]
          }
        end

        def event
          fields[:event].pages.first
        end

        def day
          if event.fields[:start_date].data_present?
            event.fields[:start_date].value.strftime("%a %b %-d")
          end
        end

        def start_time
          if event.fields[:start_date].data_present?
            event.fields[:start_date].value.strftime("%-l:%M%p")
          end
        end

        def end_time
          if event.fields[:end_date].data_present?
            event.fields[:end_date].value.strftime("%-l:%M%p")
          end
        end

        def speakers
          if event.fields[:presenters].data_present?
            event.fields[:presenters].pages
          end
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
