module Heracles
  module Sites
    module WheelerCentre
      class PodcastSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :feature_image, type: :asset, asset_file_type: :image},
              {name: :description, type: :content},
              {name: :itunes_categories, type: :array},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ],
            default_children: {
              type: :collection,
              slug: "episodes",
              title: "Episodes",
              fields: {
                contained_page_type: { value: :podcast_episode },
                sort_attribute: { value: "created_at" },
                sort_direction: { value: "DESC" }
              },
              published: false,
              locked: true
            }
          }
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          text :description do
            fields[:description].value
          end
        end
      end
    end
  end
end
