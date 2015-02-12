module Heracles
  module Sites
    module WheelerCentre
      class VplaYear < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, type: :content},
              {name: :body, type: :content},
              {name: :year, type: :integer},
            ]
          }
        end

        ### Accessors

        def categories
          children.published.of_type("vpla_category").in_order
        end
      end
    end
  end
end
