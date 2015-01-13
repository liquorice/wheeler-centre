module Heracles
  module Sites
    module WheelerCentre
      class Topics < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content}
            ]
          }
        end

        ### Accessors

        def primary_topics
          children.visible.published.of_type("topic")
        end
      end
    end
  end
end
