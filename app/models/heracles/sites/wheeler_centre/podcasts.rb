module Heracles
  module Sites
    module WheelerCentre
      class Podcasts < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content}
            ]
          }
        end

        ### Accessors

        def series
          children.of_type(:podcast_series).visible.published.in_order
        end

      end
    end
  end
end
