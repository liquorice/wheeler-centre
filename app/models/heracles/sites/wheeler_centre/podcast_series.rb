module Heracles
  module Sites
    module WheelerCentre
      class PodcastSeries < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :assets, assets_file_type: :image},
              {name: :highlight_colour, type: :text, defaults: {value: '#F8F59E'}},
              {name: :intro, type: :content},
              {name: :description, type: :content},
              {name: :explicit, type: :boolean, defaults: {value: false}, question_text: "Mark series as explicit?"},
              {name: :featured, type: :boolean, defaults: {value: false}, question_text: "Make featured podcast"},
              # iTunes
              {name: :itunes_info, type: :info, text: "<hr/>"},
              {name: :itunes_url, type: :text},
              {name: :itunes_image, type: :assets, assets_file_type: :image},
              {name: :itunes_subtitle, type: :text},
              {name: :itunes_summary, type: :text},
              {name: :itunes_description, type: :text},
              {name: :itunes_keywords, type: :text},
              {name: :itunes_categories, type: :associated_pages, page_type: :itunes_category},
              # Other podcast sources
              {name: :google_podcasts_url, type: :text, label: "Google Podcasts URL"},
              {name: :pocket_casts_url, type: :text, label: "Pocket Casts URL"},
              {name: :radio_public_url, type: :text, label: "Radio Public URL"},
              {name: :soundcloud_url, type: :text, label: "SoundCloud URL"},
              {name: :spotify_url, type: :text, label: "Spotify URL"},
              {name: :stitcher_url, type: :text, label: "Stitcher URL"},
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

        def episodes_by_season_number(season_number)
          search_podcast_episodes_by_season_number(season_number)
        end

        def people
          if fields[:people].data_present?
            fields[:people].pages.visible.published
          end
        end

        def itunes_categories
          # Sort the categories into an ordered tree
          all_categories = []
          fields[:itunes_categories].pages.each do |category|
            all_categories << category
            find_parent_categories(category, all_categories)
          end
          top_level_categories = all_categories.select {|c| c.parent.page_type == "placeholder"}
          build_category_tree(top_level_categories, all_categories)
        end

        def season_numbers
          results = PodcastEpisode.where(
            site_id: site.id,
            hidden: false,
            published: true
          )
          .children_of(self)
          .pluck("fields_data->'season_number'->>'value'")
          .compact
          .uniq
          .map(&:to_i)
          .sort
          .reverse
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

          string :person_ids, multiple: true do
            fields[:people].pages.map(&:id)
          end

          string :person_titles, multiple: true do
            fields[:people].pages.map(&:title)
          end

          text :description do
            fields[:description].value
          end
        end

        private

        def search_podcast_episodes(options={})
          results = PodcastEpisode.where(
            site_id: site.id,
            hidden: false,
            published: true
          )
          .children_of(self)
          .order("fields_data->'publish_date'->>'value' DESC NULLS LAST")

          if options[:type] == "video"
            results = results.where("fields_data->'video'->>'asset_ids' != '[]'") # without :video_id, nil
          else
            results = results.where("fields_data->'audio'->>'asset_ids' != '[]'") # without :audio_id, nil
          end
          results.page(options[:page] || 1).per(options[:per_page] || 20)

          # Sunspot.search(PodcastEpisode) do
          #   with :site_id, site.id
          #   with :parent_id, id
          #   with :hidden, false
          #   with :published, true

          #   if options[:type] == "video"
          #     without :video_id, nil
          #   else
          #     without :audio_id, nil
          #   end

          #   order_by :publish_date_time, :desc

          #   paginate page: options[:page] || 1, per_page: options[:per_page] || 20
          # end
        end

        def search_podcast_episodes_by_season_number(season_number)
          PodcastEpisode.where(
            site_id: site.id,
            hidden: false,
            published: true
          )
          .children_of(self)
          .where("fields_data->'season_number'->>'value' = ?", season_number.to_s)
          .order("fields_data->'publish_date'->>'value' DESC NULLS LAST")
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
