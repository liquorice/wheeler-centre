module Heracles
  module Sites
    module WheelerCentre
      class LongView < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
            ]
          }
        end

        ### Accessors

        def review
          children.of_type("long_view_review").in_order.visible.published
        end

      end
    end
  end
end
