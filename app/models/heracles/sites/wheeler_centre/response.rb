module Heracles
  module Sites
    module WheelerCentre
      class Response < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :body, type: :content},
              {name: :author, type: :content},
              {name: :url, type: :text},
            ]
          }
        end
      end
    end
  end
end
