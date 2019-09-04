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

        def start_time
          event.fields[:start_date].value.strftime("%-l:%M%p")
        end

        def end_time
          event.fields[:end_date].value.strftime("%-l:%M%p")
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
