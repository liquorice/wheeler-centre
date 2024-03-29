module Heracles
  module Sites
    module WheelerCentre
      class Venues < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
              {name: :main_venues, type: :associated_pages, page_type: :venue},
            ]
          }
        end

        def venues
          search_venues
        end

        def main_venues
          fields[:main_venues].pages
        end

        def other_venues
          main_venue_ids = main_venues.map(&:id) if main_venues
          children.
          where.not(
            id: main_venue_ids
          ).
          of_type("venue").
          published.
          visible.
          order(:title)
        end

        private

        def search_venues
          Venues.where(
            site_id: site.id,
            published: true,
            hidden: false
          )
          .children_of(Venues.find(id))
          .order(:title)
          .page(1)
          .per(1000)

          # Sunspot.search(Venues) do
          #   with :site_id, site.id
          #   with :parent_id, id
          #   with :published, true
          #   with :hidden, false

          #   order_by :title, :asc
          #   paginate(page: 1, per_page: 1000)
          # end
        end
      end
    end
  end
end
