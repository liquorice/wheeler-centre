module Heracles
  module Sites
    module WheelerCentre
      class ZooFellowships < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
            ]
          }
        end

        ### Accessors

        def works
          children.of_type("zoo_fellowships_work").in_order.visible.published
        end

      end
    end
  end
end
