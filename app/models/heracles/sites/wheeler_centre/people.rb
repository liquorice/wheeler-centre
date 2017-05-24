module Heracles
  module Sites
    module WheelerCentre
      class People < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
              # Coming up intro
              {name: :coming_up_info, type: :info, text: "<hr/>"},
              {name: :coming_up_intro, type: :content}
            ]
          }
        end

        # Options:
        # - page: 1
        # - per_page: 2
        # - order_by: "first_name"
        def people(options={})
          search_people(options)
        end

        # Recently appeared
        # Find recent events
        def people_from_recent_events(options={})
          recent_events = search_recent_events options
          people = []
          recent_events.each do |event|
            people = people + event.fields[:presenters].pages.visible.published
          end
          people.uniq.first(12)
        end

        # Coming up
        def people_from_upcoming_events(options={})
          upcoming_events = search_upcoming_events options
          people = []
          upcoming_events.each do |event|
            people = people + event.fields[:presenters].pages.visible.published
          end
          people.uniq.first(12)
        end

        private

        def search_people(options={})
          results = Person.where(
            site_id: site.id,
            published: true,
            hidden: false,
          )
          .children_of(People.find(id))

          # Need to sort by first_name/last_name and then title for those sans-one or the other
          if options[:order_by] == "first_name"
            results = results.where("fields_data->'first_name'->>'value' iLIKE ? ", "#{options[:letter].downcase}%") if options[:letter]
            results = results.order("fields_data->'first_name'->>'value' ASC")
            .order("fields_data->'last_name'->>'value' ASC")
          else
            results = results.where("fields_data->'last_name'->>'value' iLIKE ? ", "#{options[:letter].downcase}%") if options[:letter]
            results = results.order("fields_data->'first_name'->>'value' ASC")
            .order("fields_data->'last_name'->>'value' ASC")
          end
          results.page(options[:page] || 1).per(options[:per_page] || 50)

          # Sunspot.search(Person) do
          #   with :site_id, site.id
          #   with :parent_id, id
          #   with :published, true
          #   with :hidden, false

          #   # Need to sort by first_name/last_name and then title for those sans-one or the other
          #   if options[:order_by] == "first_name"
          #     with :sort_first_name_first_letter, options[:letter].downcase if options[:letter]
          #     order_by :sort_first_name, :asc
          #     order_by :sort_last_name, :asc
          #   else
          #     with :sort_last_name_first_letter, options[:letter].downcase if options[:letter]
          #     order_by :sort_last_name, :asc
          #     order_by :sort_first_name, :asc
          #   end

          #   paginate page: options[:page] || 1, per_page: options[:per_page] || 50
          # end
        end

        def search_recent_events(options={})
          Event.where(
            site_id: site.id,
            published: true,
            hidden: false,
          )
          .where("fields_data->'start_date'->>'value' <= ? ", Time.zone.now.beginning_of_day)
          .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
          .page(options[:page] || 1)
          .per(options[:per_page] || 12)

          # Sunspot.search(Event) do
          #   with :site_id, site.id
          #   with :published, true
          #   with :hidden, false
          #   with(:start_date_time).less_than_or_equal_to(Time.zone.now.beginning_of_day)
          #   order_by :start_date_time, :desc
          #   paginate(page: options[:page] || 1, per_page: options[:per_page] || 12)
          # end
        end

        def search_upcoming_events(options={})
          Event.where(
            site_id: site.id,
            published: true,
            hidden: false,
          )
          .where("fields_data->'start_date'->>'value' >= ? ", Time.zone.now.beginning_of_day)
          .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
          .page(options[:page] || 1)
          .per(options[:per_page] || 12)

          # Sunspot.search(Event) do
          #   with :site_id, site.id
          #   with :published, true
          #   with :hidden, false
          #   with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)
          #   order_by :start_date_time, :desc
          #   paginate(page: options[:page] || 1, per_page: options[:per_page] || 12)
          # end
        end
      end
    end
  end
end
