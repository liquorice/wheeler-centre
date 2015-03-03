module Heracles
  module Sites
    module WheelerCentre
      class EventSeriesIndex < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
              # Active intro
              {name: :active_info, type: :info, text: "<hr/>"},
              {name: :active_intro, type: :content},
              # Inactive intro
              {name: :inactive_info, type: :info, text: "<hr/>"},
              {name: :inactive_intro, type: :content},
            ]
          }
        end

        ### Accessors

        def event_series(options={})
          search_event_series(options)
        end

        def active_series(options={})
          options.reverse_merge!({active: true})
          search_event_series(options)
        end

        def inactive_series(options={})
          options.reverse_merge!({active: false})
          search_event_series(options)
        end

        private

        def search_event_series(options={})
          Sunspot.search(EventSeries) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true
            with :hidden, false

            if options[:active] == true
              with :archived, false
              without :event_ids, nil
            elsif options[:active] == false
              without :archived, false
              without :event_ids, nil
            end

            order_by :title, :asc
            paginate(page: 1, per_page: 1000)
          end
        end
      end
    end
  end
end
