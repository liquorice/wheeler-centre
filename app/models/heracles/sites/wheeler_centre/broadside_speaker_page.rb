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
          if person && person.fields[:biography].data_present?
            person.fields[:biography].value
          end
        end

        def portrait_url
          if person && person.fields[:portrait].data_present?
            person.fields[:portrait].assets.first.content_thumbnail_url
          end
        end

        def related_broadside_events
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

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end
      end
    end
  end
end
