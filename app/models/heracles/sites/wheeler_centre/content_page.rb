module Heracles
  module Sites
    module WheelerCentre
      class ContentPage < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          string :topic_titles, multiple: true do
            fields[:topics].pages.map(&:title)
          end
        end
      end
    end
  end
end
