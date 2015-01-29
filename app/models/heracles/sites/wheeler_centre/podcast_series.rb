module Heracles
  module Sites
    module WheelerCentre
      class PodcastSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :description, type: :content},
              {name: :explicit, type: :boolean, defaults: {value: false}, question_text: "Mark series as explicit?"},
              # iTunes
              {name: :itunes_info, type: :info, text: "<hr/>"},
              {name: :itunes_image, type: :asset, asset_file_type: :image},
              {name: :itunes_subtitle, type: :text},
              {name: :itunes_summary, type: :text},
              {name: :itunes_description, type: :text},
              {name: :itunes_keywords, type: :text},
              {name: :itunes_categories, type: :associated_pages, page_type: :itunes_category},
              # Extra
              {name: :extra_info, type: :info, text: "<hr/>"},
              {name: :people, type: :associated_pages, page_type: :person},
              {name: :topics, type: :associated_pages, page_type: :topic},
              {name: :legacy_program_id, type: :integer, label: "Legacy program ID"},
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

        # Accessors

        def episodes(options={})
          search_podcast_episodes(options)
        end

        def itunes_categories
          # Sort the categories into a ordered tree
          all_categories = []
          fields[:itunes_categories].pages.each do |category|
            all_categories << category
            find_parent_categories(category, all_categories)
          end
          top_level_categories = all_categories.select {|c| c.parent.page_type == "placeholder"}
          build_category_tree(top_level_categories, all_categories)
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          text :description do
            fields[:description].value
          end
        end

        private

        def search_podcast_episodes(options={})
          Sunspot.search(PodcastEpisode) do
            with :site_id, site.id
            with :parent_id, id
            with :published, true

            without :audio_id, nil

            order_by :publish_date_time, :desc

            paginate page: options[:page] || 1, per_page: options[:per_page] || 20
          end
        end

        def find_parent_categories(category, all_categories)
          if category.parent.page_type == "itunes_category"
            all_categories << category.parent
            find_parent_categories(category.parent, all_categories)
          end
        end

        def build_category_tree(categories, all_categories)
          categories.map do |category|
            children = all_categories.select {|c| c.parent == category }
            child_tree = build_category_tree(children, all_categories)
            {
              category: category,
              children: child_tree
            }
          end
        end
      end
    end
  end
end
