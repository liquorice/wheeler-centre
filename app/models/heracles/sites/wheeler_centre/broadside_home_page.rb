module Heracles
  module Sites
    module WheelerCentre
      class BroadsideHomePage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
            ]
          }
        end
      end
    end
  end
end
