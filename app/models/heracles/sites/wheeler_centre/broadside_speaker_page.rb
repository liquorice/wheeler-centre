module Heracles
  module Sites
    module WheelerCentre
      class BroadsideSpeakerPage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :person, type: :associated_pages, page_type: :person, label: "Person", editor_type: 'singular'},
            ]
          }
        end

        def person
          fields[:person].pages.first
        end

        def biography
          # seems like intro is what's used mostly
          if person && person.fields[:intro].data_present?
            person.fields[:intro].value
          end
        end

        def twitter_name
          if person && person.fields[:twitter_name].data_present?
            person.fields[:twitter_name].value
          end
        end

        def large_url
          if person && person.fields[:portrait].data_present?
            person.fields[:portrait].assets.first.content_large_url
          end
        end

        def portrait_url
          if person && person.fields[:portrait].data_present?
            person.fields[:portrait].assets.first.content_thumbnail_url
          end
        end

        def saturday_event_pages
          related_event_pages_grouped["Sat"]
        end

        def sunday_event_pages
          related_event_pages_grouped["Sun"]
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end

        private

        def related_event_pages_grouped
          related_event_pages.group_by do |event_page|
            event_page.event.fields[:start_date].value.strftime("%a")
          end
        end

        def related_event_pages
          if person && person.upcoming_events
            person.upcoming_events.map do |event|
              BroadsideEventPage.where(
                site_id: site.id,
                published: true,
                hidden: false
              )
              .where("(fields_data#>'{event, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: event.id).all
            end.flatten
          end
        end
      end
    end
  end
end
