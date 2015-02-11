module Heracles
  module Sites
    module WheelerCentre
      class Sponsors < Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
            ]
          }
        end

        def sponsors(options={})
          search_sponsors(options)
        end

        private

        def search_sponsors(options={})
          Sunspot.search(Sponsor) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            paginate page: options[:page] || 1, per_page: options[:per_page] || 10
          end
        end
      end
    end
  end
end
