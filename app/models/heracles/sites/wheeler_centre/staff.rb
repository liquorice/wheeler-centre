module Heracles
  module Sites
    module WheelerCentre
      class Staff < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :intro, label: "Introduction", type: :content},
              {name: :body, type: :content},
              # Staff
              {name: :staff_info, type: :info, text: "<hr/>"},
              {name: :staff_title, type: :text},
              {name: :staff_content, type: :content, disable_insertables: true},
              {name: :staff_members, type: :associated_pages, page_type: :person},
              # Board
              {name: :staff_info, type: :info, text: "<hr/>"},
              {name: :board_title, type: :text},
              {name: :board_content, type: :content, disable_insertables: true},
              {name: :board_members, type: :associated_pages, page_type: :person},
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
          fields[:topics].pages.visible.published.each do |topic|
            topics = topics + topic.with_ancestors
          end
          topics
        end
      end
    end
  end
end
