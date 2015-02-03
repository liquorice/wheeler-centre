module Heracles
  module Sites
    module WheelerCentre
      class People < Heracles::Page
        def self.config
          {}
        end

        def people(options={})
          search_people(options)
        end

        private

        def search_people(options={})
          Sunspot.search(Person) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            paginate page: options[:page] || 1, per_page: options[:per_page] || 50
          end
        end
      end
    end
  end
end
