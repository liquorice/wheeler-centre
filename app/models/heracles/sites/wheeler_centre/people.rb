module Heracles
  module Sites
    module WheelerCentre
      class People < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
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
          recent_events.results.each do |event|
            people = people + event.fields[:presenters].pages
            # We only want 12
            break if people.length >= (options[:per_page] || 12)
          end
          people
        end

        # Coming up
        def people_from_upcoming_events(options={})
          upcoming_events = search_upcoming_events options
          people = []
          upcoming_events.results.each do |event|
            people = people + event.fields[:presenters].pages
            # We only want 12
            break if people.length >= (options[:per_page] || 12)
          end
          people
        end

        private

        def search_people(options={})
          Sunspot.search(Person) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            # Need to sort by first_name/last_name and then title for those sans-one or the other
            if options[:order_by] == "first_name"
              with :sort_first_name_first_letter, options[:letter].downcase if options[:letter]
              order_by :sort_first_name, :asc
              order_by :sort_last_name, :asc
            else
              with :sort_last_name_first_letter, options[:letter].downcase if options[:letter]
              order_by :sort_last_name, :asc
              order_by :sort_first_name, :asc
            end

            paginate page: options[:page] || 1, per_page: options[:per_page] || 50
          end
        end

        def search_recent_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :published, true
            with(:start_date_time).less_than_or_equal_to(Time.zone.now.beginning_of_day)
            order_by :start_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 12)
          end
        end

        def search_upcoming_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :published, true
            with(:start_date_time).greater_than_or_equal_to(Time.zone.now.beginning_of_day)
            order_by :start_date_time, :desc
            paginate(page: options[:page] || 1, per_page: options[:per_page] || 12)
          end
        end
      end
    end
  end
end
