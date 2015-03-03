module Heracles
  module Sites
    module WheelerCentre
      class LongViewReview < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :promo_image, type: :asset, asset_file_type: :image},
              {name: :body, type: :content},
              {name: :further_reading, type: :content},
              {name: :author, type: :associated_pages, page_type: :person},
            ]
          }
        end

        ### Accessors

        def author
          fields[:author].pages.visible.published.first if fields[:author].data_present?
        end
      end
    end
  end
end
