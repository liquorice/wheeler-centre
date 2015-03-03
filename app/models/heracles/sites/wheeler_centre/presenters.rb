module Heracles
  module Sites
    module WheelerCentre
      class Presenters < ::Heracles::Page
        include ApplicationHelper

        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def presenters
          search_presenters
        end

        private

        def search_presenters
          Sunspot.search(Person) do
            with :site_id, site.id
            with :published, true
            with :hidden, false

            order_by :start_date_time, :asc
            paginate(page: 1, per_page: 1000)
          end
        end
      end
    end
  end
end
