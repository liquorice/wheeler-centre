module Heracles
  module Sites
    module WheelerCentre
      class EventSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :summary, type: :content},
              {name: :body, type: :content},
              {name: :sponsors, type: :associated_pages, page_type: :sponsor},
              {name: :highlight_colour, type: :text, editor_type: 'code'},
              {name: :archived, type: :boolean, question_text: "Is the series archived?"},
              {name: :topics, type: :associated_pages, page_type: :topic},
              # Upcoming intro
              {name: :upcoming_info, type: :info, text: "<hr/>"},
              {name: :upcoming_intro, type: :content},
              # Past intro
              {name: :past_info, type: :info, text: "<hr/>"},
              {name: :past_intro, type: :content},
              {name: :legacy_series_id, type: :integer, label: "Legacy Series ID"}
            ]
          }
        end

        ### Summary

        def to_summary_hash
          events_display = if events.length == 1
            events.map(&:title).join(", ")
          elsif events.length > 1
            "#{events.length} events"
          else
            "×"
          end
          {
            title: title,
            events: events_display,
            archived: (fields[:archived].value) ? "✔" : "•",
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Accessors

        def events(options={})
          Heracles::Page.
            of_type("event").
            visible.
            published.
            where.not(
              id: options[:exclude]
            ).
            joins(:insertions).
            where(
              :"insertions.field" => "series",
              :"insertions.inserted_key" => insertion_key
            ).
            page(options[:page_number] || 1).
            per(options[:per_page] || 18)
        end

        def upcoming_events(options={})
          search_upcoming_events(options)
        end

        def past_events(options={})
          search_past_events(options)
        end

        def sponsors
          @sponsors ||= fields[:sponsors].pages.visible.published
        end

        ### Searchable

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          string :topic_titles, multiple: true do
            fields[:topics].pages.map(&:title)
          end

          string :event_ids, multiple: true do
            events.map(&:id)
          end

          text :body do
            fields[:body].value
          end

          date :created_at do
            created_at.to_s(:admin_date)
          end

          boolean :archived do
            fields[:archived].value
          end
        end

        private

        def search_upcoming_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :event_series_ids, id
            with :published, true
            with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)

            order_by :start_date, :asc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 18
          end
        end

        def search_past_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :event_series_ids, id
            with :published, true
            with(:start_date_time).less_than(Time.zone.now.beginning_of_day)

            order_by :start_date, :desc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 18
          end
        end

      end
    end
  end
end
