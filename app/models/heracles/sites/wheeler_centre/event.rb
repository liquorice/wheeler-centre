module Heracles
  module Sites
    module WheelerCentre
      class Event < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title"},
              {name: :promo_image, type: :asset, asset_file_type: :image},
              {name: :thumbnail_image, type: :asset, asset_file_type: :image, hint: "Set this to override the above promo image in listings"},
              {name: :body, type: :content},
              {name: :external_video, type: :external_video, label: 'External video'},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :start_date, type: :date_time, label: "Event start date"},
              {name: :end_date, type: :date_time, label: "Event end date"},
              {name: :display_date, type: :text, hint: "Specify this if you want to customise the display of the date/time"},
              # Venues
              {name: :venue, type: :associated_pages, page_type: :venue, label: "Venue", editor_type: 'singular'},
              # Bookings
              {name: :booking_info, type: :info, text: "<hr/>"},
              {name: :bookings_open_at, type: :date_time, label: "Bookings open on"},
              {name: :external_bookings, type: :text, label: "External bookings"},
              # Other
              {name: :presenters, type: :associated_pages, page_type: :person},
              {name: :series, type: :associated_pages, page_type: :event_series, editor_type: 'singular'},
              {name: :recordings, type: :associated_pages, page_type: :recording, editor_columns: 6},
              {name: :podcast_episodes, type: :associated_pages, page_type: :podcast_episode, editor_columns: 6},
              {name: :life_stage, type: :text, label: "Life stage"},
              {name: :ticketing_stage, type: :text, label: "Ticketing stage"},
              {name: :promo_text, type: :text, label: "Promo text", hint: "2-3 words to highlight event in listings"},
              {name: :sponsors_intro, type: :content, hint: "Override the 'Made possible with the support of' text"},
              {name: :sponsors, type: :associated_pages, page_type: :sponsor},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            series: fields[:series].pages.map(&:title).join(", "),
            recordings: fields[:recordings],
            start_date: fields[:start_date],
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Accessors

        def series
          if fields[:series].data_present?
            fields[:series].pages.first
          end
        end

        def venue
          if fields[:venue].data_present?
            fields[:venue].pages.first
          end
        end

        def related_events(options={})
          options[:per_page] = 6 || options[:per_page]
          if series
            events = series.events({per_page: options[:per_page]})
            if events.total < options[:per_page]
              additional_total = options[:per_page] - events.total
              additional = search_events_by_topic({per_page: additional_total})
              events = events.results + additional.results
            else
              events = events.results
            end
          else
            events = search_events_by_topic({per_page: options[:per_page]}).results
          end
          events
        end


        ### Searchable attrs

        searchable do
          string :id do |page|
            page.id
          end

          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          text :body do
            fields[:body].value
          end

          date :start_date do
            fields[:start_date].value
          end

          time :start_date_time do
            fields[:start_date].value
          end

          date :end_date do
            fields[:end_date].value
          end

          time :end_date_time do
            fields[:end_date].value
          end

          string :event_series_ids, multiple: true do
            fields[:series].pages.map(&:id)
          end

        end

        private

        def search_events_by_topic(options={})
          Sunspot.search(Event) do
            without :id, id
            with :site_id, site.id
            with :topic_ids, fields[:topics].pages.map(&:id)
            with :published, true

            order_by :start_date_time, :asc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 18)
          end
        end
      end
    end
  end
end
