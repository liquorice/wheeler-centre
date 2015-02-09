module Heracles
  module Sites
    module WheelerCentre
      class Venue < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :address, type: :text, hint: "Not displayed on site, used for address lookups on Google Maps"},
              {name: :address_formatted, type: :content, hint: "Nicely formatted for display on the site"},
              {name: :phone_number, type: :text},
              {name: :description, type: :content},
              {name: :directions, type: :content},
              {name: :parking, type: :content},
              {name: :legacy_venue_id, type: :text, label: "Legacy Venue ID"},
            ]
          }
        end


        ### Accessors

        def map_data
          {
            title: title,
            address: fields[:address].value,
            address_formatted: fields[:address_formatted].value
          }.to_json
        end

        def events(options={})
          search_events(options)
        end

        ### Searchable

        searchable do
          text :title do
            title
          end
        end

        private

        def search_events(options={})
          Sunspot.search(Event) do
            with :site_id, site.id
            with :venue_id, id
            with :published, true

            order_by :start_date, :desc
            paginate page: options[:page] || 1, per_page: options[:per_page] || 14
          end
        end

      end
    end
  end
end
