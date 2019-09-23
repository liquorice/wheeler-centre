module Heracles
  module Sites
    module WheelerCentre
      class BroadsideEventPage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :event, type: :associated_pages, page_type: :event, label: "Event", editor_type: 'singular', required: true},
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

        def speaker_names
          if event.fields[:presenters].data_present?
            event.fields[:presenters].pages.map(&:title).join(", ")
          end
        end

        def broadside_speaker_pages
          if event.fields[:presenters].data_present?
            BroadsideSpeakerPage.where(
              site_id: site.id,
              published: true,
              hidden: false
            )
            .where("(fields_data#>'{person, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: event.fields[:presenters].pages.map(&:id))
          end
        end

        def ticketing_stage
          if event && event.fields[:ticketing_stage].data_present?
            event.fields[:ticketing_stage].value
          end
        end

        def on_saturday?
          if event && event.fields[:start_date].data_present?
            event.fields[:start_date].value.strftime("%a") == "Sat"
          end
        end

        def on_sunday?
          if event && event.fields[:start_date].data_present?
            event.fields[:start_date].value.strftime("%a") == "Sun"
          end
        end

        def external_bookings
          if event && event.fields[:external_bookings].data_present?
            event.fields[:external_bookings].value
          end
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
