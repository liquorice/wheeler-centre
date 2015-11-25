module Heracles
  module Sites
    module WheelerCentre
      class Event < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title", hint: "(optional) Set this to override the title in listings"},
              {name: :promo_image, type: :asset, asset_file_type: :image},
              {name: :thumbnail_image, type: :asset, asset_file_type: :image, hint: "(optional) Set this to override the above promo image in listings"},
              {name: :body, type: :content},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :start_date, type: :date_time, label: "Event start date"},
              {name: :end_date, type: :date_time, label: "Event end date"},
              {name: :display_date, type: :text, hint: "Specify this if you want to customise the display of the date/time"},
              # Venues
              {name: :venue, type: :associated_pages, page_type: :venue, label: "Venue", editor_type: 'singular'},
              # Bookings
              {name: :booking_info, type: :info, text: "<hr/>"},
              {name: :ticket_prices, type: :text},
              {name: :bookings_open_at, type: :date_time, label: "Bookings open on"},
              {name: :external_bookings, type: :text, label: "External bookings URL"},
              # Other
              {name: :presenters, type: :associated_pages, page_type: :person},
              {name: :series, type: :associated_pages, page_type: :event_series},
              {name: :recordings, type: :associated_pages, page_type: :recording, editor_columns: 6},
              {name: :podcast_episodes, type: :associated_pages, page_type: :podcast_episode, editor_columns: 6},
              {name: :ticketing_stage, type: :text, editor_type: 'select', option_values: [ "Booking fast", "Booked out", "Cancelled" ] },
              {name: :promo_text, type: :text, label: "Promo text", hint: "2-3 words to highlight event in listings"},
              {name: :sponsors_intro, type: :content, hint: "Override the 'Presented in partnership with' text"},
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
            start_date: fields[:start_date],
            promo_image: (fields[:promo_image].data_present?) ? "✔" : "•",
            booking: (fields[:external_bookings].data_present?) ? "✔" : "•",
            recordings: fields[:recordings],
            published: (published) ? "✔" : "•"
          }
        end

        def summary_title
          fields[:short_title].data_present? ? fields[:short_title] : title
        end

        def summary
          if fields[:summary].data_present?
            fields[:summary]
          elsif fields[:intro].data_present?
            fields[:intro]
          else
            fields[:body]
          end
        end

        ### Accessors

        def upcoming?
          (fields[:start_date].data_present? && fields[:start_date].value >= Time.zone.now.beginning_of_day)
        end

        def booked_out?
          (fields[:ticketing_stage].value == "Booked out")
        end

        def recordings
          if fields[:recordings].data_present?
            fields[:recordings].pages.visible.published
          end
        end

        def series
          if fields[:series].data_present?
            fields[:series].pages.visible.published.first
          end
        end

        def secondary_series
          if fields[:series].data_present? && fields[:series].pages.visible.published.count > 1
            fields[:series].pages.visible.published.to_a.drop(1)
          end
        end

        def venue
          if fields[:venue].data_present?
            fields[:venue].pages.visible.published.first
          end
        end

        def presenters
          if fields[:presenters].data_present?
            fields[:presenters].pages.visible.published
          end
        end

        def related_events(options={})
          options[:per_page] = 6 || options[:per_page]
          if series
            events = series.events({per_page: options[:per_page], exclude: [id]})
            # Try and find events based on presenters
            if events.length < options[:per_page]
              additional_total = options[:per_page] - events.length
              additional = search_events_by_presenters({per_page: additional_total})
              events = events + additional.results
            end
            # Try and find events based on topics
            if events.length < options[:per_page]
              additional_total = options[:per_page] - events.length
              additional = search_events_by_topic({per_page: additional_total})
              events = events + additional.results
            end
          else
            events = search_events_by_presenters({per_page: options[:per_page]}).results
            # Try and find events based on topics
            if events.length < options[:per_page]
              additional_total = options[:per_page] - events.length
              additional = search_events_by_topic({per_page: additional_total})
              events = events + additional.results
            end
          end
          events
        end

        def promo_image
          if fields[:promo_image].data_present?
            fields[:promo_image].asset
          elsif fields[:presenters].data_present?
            primary_presenter = fields[:presenters].pages.first
            primary_presenter.fields[:portrait].asset if primary_presenter.fields[:portrait].data_present?
          end
        end

        ### Searchable attrs

        searchable do
          string :id do |page|
            page.id
          end

          string :topic_ids, multiple: true do
            topics_with_ancestors.map(&:id)
          end

          string :topic_titles, multiple: true do
            topics_with_ancestors.map(&:title)
          end

          string :tag_list, multiple: true do
            tags.map(&:name)
          end

          string :presenter_ids, multiple: true do
            fields[:presenters].pages.map(&:id)
          end

          string :presenter_titles, multiple: true do
            fields[:presenters].pages.map(&:title)
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

          string :event_series_titles, multiple: true do
            fields[:series].pages.map(&:title)
          end

          string :venue_id do
            fields[:venue].pages.first.id if fields[:venue].data_present?
          end

          time :sort_field do
            created_at
          end

        end

        private

        def search_events_by_presenters(options={})
          Sunspot.search(Event) do
            without :id, id
            with :site_id, site.id
            with :presenter_ids, fields[:presenters].pages.map(&:id)
            with :published, true
            with :hidden, false

            order_by :start_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 18)
          end
        end

        def search_events_by_topic(options={})
          Sunspot.search(Event) do
            without :id, id
            with :site_id, site.id
            with :topic_ids, fields[:topics].pages.map(&:id)
            with :published, true
            with :hidden, false

            order_by :start_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 18)
          end
        end

        # Topics with their ancestors parents for search purposes
        def topics_with_ancestors
          topics = []
          fields[:topics].pages.visible.published.each do |topic|
            topics = topics + topic.with_ancestors
          end
          topics
        end
      end
    end
  end
end
