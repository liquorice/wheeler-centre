module Heracles
  module Sites
    module WheelerCentre
      class Person < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :first_name, type: :text},
              {name: :last_name, type: :text},
              {name: :portrait, type: :asset, asset_file_type: :image},
              {name: :intro, type: :content},
              {name: :biography, type: :content},
              {name: :url, type: :text},
              {name: :reviews, type: :content},
              {name: :external_links, type: :content},
              {name: :is_staff_member, type: :boolean, defaults: {value: false}, question_text: "Is a Wheeler Centre staff member?"},
              {name: :staff_bio, type: :content, label: "Staff biography", display_if: 'is_staff_member.value'},
              {name: :position_title, type: :text, display_if: 'is_staff_member.value'},
              {name: :legacy_user_id, type: :integer, label: "Legacy User ID"},
              {name: :legacy_presenter_id, type: :integer, label: "Legacy Presenter ID"},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            first_name: fields[:first_name],
            last_name: fields[:last_name],
            portrait: (fields[:portrait].data_present?) ? "✔" : "•",
            staff: (fields[:is_staff_member].value) ? "✔" : "•",
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Accessors

        def upcoming_events(options={})
          search_upcoming_events(options)
        end

        def past_events(options={})
          search_past_events(options)
        end

        def recordings(options={})
          Heracles::Page.
            of_type("recording").
            visible.
            published.
            joins(:insertions).
            where(
              :"insertions.field" => "people",
              :"insertions.inserted_key" => insertion_key
            ).
            page(options[:page_number] || 1).
            per(options[:per_page] || 18)
        end

        def blog_posts(options={})
          Heracles::Page.
            of_type("blog_post").
            visible.
            published.
            joins(:insertions).
            where(
              :"insertions.field" => "authors",
              :"insertions.inserted_key" => insertion_key
            ).
            page(options[:page_number] || 1).
            per(options[:per_page] || 18)
        end

        def podcasts
          # Through events
        end

        ### Searchable

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          string :topic_titles, multiple: true do
            fields[:topics].pages.map(&:title)
          end

          text :first_name do
            fields[:first_name].value
          end

          text :last_name do
            fields[:last_name].value
          end

          text :intro do
            fields[:intro].value
          end

          text :biography do
            fields[:biography].value
          end

          text :url do
            fields[:url].value
          end

          text :reviews do
            fields[:reviews].value
          end

          text :external_links do
            fields[:external_links].value
          end

          time :created_at do
            created_at
          end

          time :updated_at do
            updated_at
          end
        end

        private

        def search_upcoming_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :presenter_ids, id
            with :published, true
            with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)

            order_by :start_date, :asc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 18
          end
        end

        def search_past_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :presenter_ids, id
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
