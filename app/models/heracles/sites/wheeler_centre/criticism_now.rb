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

        def primary_responses
          child = events.find_by_slug("criticism-in-the-digital-age")
          child.responses
        end
      end
    end
  end
end
