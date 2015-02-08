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
          if fields[:main_venues].data_present?
            fields[:main_venues].pages
          end
        end

        def other_venues
          children.
          where.not(
            id: main_venues.map(&:id)
          ).
          of_type("venue").
          published.
          order(:title)
        end

        private

        def search_venues
          Sunspot.search(Venues) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            order_by :title, :asc
            paginate(page: 1, per_page: 1000)
          end
        end
      end
    end
  end
end
