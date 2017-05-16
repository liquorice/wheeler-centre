module Heracles
  module Sites
    module WheelerCentre
      class Guests < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def guests
          search_guests
        end

        private

        def search_guests
          Person.where(
            site_id: site.id,
            published: true,
            hidden: false
          )
          .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
          .page(1)
          .per(1000)

          # Sunspot.search(Person) do
          #   with :site_id, site.id
          #   with :published, true
          #   with :hidden, false

          #   order_by :start_date_time, :asc
          #   paginate(page: 1, per_page: 1000)
          # end
        end
      end
    end
  end
end
