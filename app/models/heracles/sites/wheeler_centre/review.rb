module Heracles
  module Sites
    module WheelerCentre
      class Review < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
              {name: :reviewer, type: :text}
            ]
          }
        end
      end
    end
  end
end
