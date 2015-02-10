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
            topics_with_ancestors.map(&:id)
          end

          string :topic_titles, multiple: true do
            topics_with_ancestors.map(&:title)
          end

          string :tag_list, multiple: true do
            tags.map(&:name)
          end
        end

        private

        # Topics with their ancestors parents for search purposes
        def topics_with_ancestors
          topics = []
          fields[:topics].pages.each do |topic|
            topics = topics + topic.with_ancestors
          end
          topics
        end
      end
    end
  end
end
