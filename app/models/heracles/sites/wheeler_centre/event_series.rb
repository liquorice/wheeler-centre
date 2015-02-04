module Heracles
  module Sites
    module WheelerCentre
      class EventSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :body, type: :content},
              {name: :sponsors, type: :associated_pages, page_type: :sponsor},
              {name: :highlight_colour, type: :text, editor_type: 'code'},
              {name: :archived, type: :boolean, question_text: "Is the Event Series archived?"},
              {name: :topics, type: :associated_pages, page_type: :topic},
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

        def events
          Heracles::Page.
            of_type("event").
            joins(:insertions).
            where(
              :"insertions.field" => "series",
              :"insertions.inserted_key" => insertion_key
            )
        end

        def upcoming_events(options={})
          search_events(options)
        end

        def sponsors
           @sponsors ||= fields["sponsors"].pages.published
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          string :topic_titles, multiple: true do
            fields[:topics].pages.map(&:title)
          end

          text :body do
            fields[:body].value
          end

          date :created_at do
            created_at.to_s(:admin_date)
          end
        end

        private

        def search_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :event_series_ids, id
            with :published, true

            order_by :start_date, :asc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 18
          end
        end



      end
    end
  end
end
