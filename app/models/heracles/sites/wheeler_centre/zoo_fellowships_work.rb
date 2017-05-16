module Heracles
  module Sites
    module WheelerCentre
      class ZooFellowshipsWork < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :promo_image, type: :assets, asset_file_type: :image},
              {name: :body, type: :content},
              {name: :further_reading, type: :content},
              {name: :author, type: :associated_pages, page_type: :person},
            ]
          }
        end

        ### Accessors

        def author
          if fields[:author].data_present?
            fields[:author].pages.first
          end
        end
      end
    end
  end
end
