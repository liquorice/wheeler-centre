module Heracles
  module Sites
    module WheelerCentre
      class BroadsideWatchPage < ::Heracles::Page
        def self.config
          {
            fields: []
          }
        end

        def absolute_url
          super.gsub(/^\/broadside/, "")
        end

        def recordings
          broadside_events.map {|event|
            event.recordings
          }.flatten
        end

        def podcast_episodes
          broadside_events.map {|event|
            event.podcast_episodes
          }.flatten
        end

        private

        memoize \
        def broadside_events
          broadside_series = Heracles::Page.of_type(:event_series).find_by(title: "Broadside")
          Heracles::Page.of_type(:event).where("(fields_data#>'{series, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: broadside_series.id).order("fields_data->'start_date'->>'value' ASC NULLS LAST")
        end
      end
    end
  end
end
