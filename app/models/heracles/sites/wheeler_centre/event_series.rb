module Heracles
  module Sites
    module WheelerCentre
      class EventSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :assets, assets_file_type: :image},
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
            per(options[:per_page] || 1000)
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

          string :title do
            title
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

          string :event_ids, multiple: true do
            events.map(&:id)
          end

          text :body do
            fields[:body].value
          end

          boolean :archived do
            fields[:archived].value
          end
        end

        def csv_headers
          [
            "ID",
            "Title",
            "Hero image",
            "Summary",
            "Body",
            "Sponsor IDs"
          ]
        end

        def to_csv
          [
            id,
            title,
            (fields[:hero_image].assets.first.original_url if fields[:hero_image].data_present?),
            fields[:summary],
            fields[:body],
            (fields[:sponsors].pages.map(&:id).join(",") if fields[:sponsors].data_present?),
          ]
        end

        private

        def search_upcoming_events(options={})
          Event.where(
            site_id: site.id,
            published: true,
            hidden: false
          )
          .where("(fields_data#>'{series, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: id)
          .where("fields_data->'start_date'->>'value' >= ? ", Time.zone.now.beginning_of_day)
          .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
          .page(options[:page] || 1)
          .per(options[:per_page] || 18)

          # Sunspot.search(Event) do
          #   with :site_id, site.id
          #   with :event_series_ids, id
          #   with :published, true
          #   with :hidden, false
          #   with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)

          #   order_by :start_date, :asc
          #   paginate page: options[:page] || 1, per_page: options[:per_page] || 18
          # end
        end

        def search_past_events(options={})
          Event.where(
            site_id: site.id,
            published: true,
            hidden: false,
          )
          .where("(fields_data#>'{series, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: id)
          .where("fields_data->'start_date'->>'value' <= ? ", Time.zone.now.beginning_of_day)
          .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
          .page(options[:page] || 1)
          .per(options[:per_page] || 18)

          # Sunspot.search(Event) do
          #   with :site_id, site.id
          #   with :event_series_ids, id
          #   with :published, true
          #   with :hidden, false
          #   with(:start_date_time).less_than(Time.zone.now.beginning_of_day)

          #   order_by :start_date, :desc
          #   paginate page: options[:page] || 1, per_page: options[:per_page] || 18
          # end
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
