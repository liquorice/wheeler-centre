module Heracles
  module Sites
    module WheelerCentre
      class VplaYear < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content}
            ]
          }
        end
      end
    end
  end
end
