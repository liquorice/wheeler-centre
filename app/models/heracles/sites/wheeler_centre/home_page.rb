module Heracles
  module Sites
    module WheelerCentre
      class HomePage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :banners, label: "Home page banners", type: :associated_pages, page_type: :home_banner},
            ]
          }
        end

        ### Accessors

        def sorted_banners
          if fields[:banners].data_present?
            fields[:banners].pages.first(9)
          end
        end
      end
    end
  end
end
