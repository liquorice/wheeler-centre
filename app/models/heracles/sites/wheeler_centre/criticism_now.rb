module Heracles
  module Sites
    module WheelerCentre
      class CriticismNow < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Accessors

        def events
          children.of_type("criticism_now_event")
        end
      end
    end
  end
end
