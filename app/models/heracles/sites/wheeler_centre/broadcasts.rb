module Heracles
  module Sites
    module WheelerCentre
      class Broadcasts < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content, hint: "Sits above everything on the page"},
              {name: :middle, type: :content, hint: "Sits between 'Latest' and 'Podcasts'"},
              {name: :end, type: :content, hint: "Sits after 'Podcasts'"},
            ]
          }
        end

        ### Accessors

        def recordings(options={})
          search_recordings(options)
        end

        private

        def search_recordings(options={})
          Sunspot.search(Recording) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true
            with :hidden, false

            without :youtube_video, nil

            order_by :recording_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 18)
          end
        end
      end
    end
  end
end
