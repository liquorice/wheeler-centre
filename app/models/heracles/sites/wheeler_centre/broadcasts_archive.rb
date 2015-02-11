module Heracles
  module Sites
    module WheelerCentre
      class BroadcastsArchive < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :nav_title, type: :text},
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def recordings(options={})
          search_recordings(options)
        end

        private

        def recordings_index
          parent
        end

        def search_recordings(options={})
          Sunspot.search(Recording) do
            with :site_id, site.id
            with :parent_id, recordings_index.id
            with :published, true
            without :youtube_video, nil

            order_by :recording_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 36)
          end
        end
      end
    end
  end
end
