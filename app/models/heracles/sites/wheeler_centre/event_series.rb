module Heracles
  module Sites
    module WheelerCentre
      class EventSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :promo_image, type: :asset, asset_file_type: :image},
              {name: :body, type: :content},
              {name: :sponsors, type: :associated_pages, page_type: :sponsor},
              {name: :archived, type: :boolean, question_text: "Is the Event Series archived?"},
              {name: :topics, type: :associated_pages, page_type: :topic},
              {name: :legacy_series_id, type: :integer, label: "Legacy Series ID"}
            ]
          }
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          date :created_at do
            created_at.to_s(:admin_date)
          end
        end

        def events(options={})
          search_events(options={})
        end

        def sponsors
           @sponsors ||= fields["sponsors"].pages.published
        end

        private

        def search_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :event_series_ids, id
            with :published, true

            order_by :start_date, :asc
          end
        end



      end
    end
  end
end
