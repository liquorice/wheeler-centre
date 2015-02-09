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
            sort_banners(fields[:banners].pages).first(9)
          end
        end

        private

        # Sort banners into [large, small, small, small, small, large, etc]
        def sort_banners(banners)
          large_banners = banners.select {|page| page.fields[:size].value == "Large" }
          small_banners = banners.select {|page| page.fields[:size].value != "Large" }
          sorted_banners = []
          banners.each_with_index do |banner, index|
            if (index % 3 == 0 && index % 5 == 0) || (index % 3 == 2 && index % 5 == 0)
              if large_banners.length > 0
                sorted_banners << {page: large_banners.shift, size: :large}
              else
                sorted_banners << {page: small_banners.shift, size: :large}
              end
            else
              if small_banners.length > 0
                sorted_banners << {page: small_banners.shift, size: :small}
              else
                sorted_banners << {page: large_banners.shift, size: :small}
              end
            end
          end
          sorted_banners
        end
      end
    end
  end
end
