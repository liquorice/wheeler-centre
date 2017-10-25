module Heracles
  module Sites
    module WheelerCentre
      class PodcastEpisode < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :hero_image, type: :assets, asset_file_type: :image},
              {name: :description, type: :content},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :recording_date, type: :date_time, label: "Recording date"},
              # Asset
              {name: :asset_info, type: :info, text: "<hr/>"},
              {name: :video, type: :assets, asset_file_type: :video},
              {name: :audio, type: :assets, asset_file_type: :audio},
              # iTunes
              {name: :itunes_info, type: :info, text: "<hr/>"},
              {name: :itunes_summary, type: :text},
              {name: :itunes_image, type: :assets, asset_file_type: :image},
              {name: :explicit, type: :boolean, defaults: {value: false}, question_text: "Mark episode as explicit?"},
              # Associations
              {name: :assoc_info, type: :info, text: "<hr/>"},
              {name: :people, type: :associated_pages, page_type: :person},
              # Extra
              {name: :extra_info, type: :info, text: "<hr/>"},
              {name: :legacy_recording_id, type: :integer, label: "Legacy recording ID"},
              {name: :topics, type: :associated_pages, page_type: :topic},
              {name: :flarum_discussion_id, type: :text, editor_type: :code},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            video: (fields[:video].data_present?) ? "✔" : "×",
            audio: (fields[:audio].data_present?) ? "♫" : "×",
            events: events.map(&:title).join(", "),
            people: fields[:people].pages.map(&:title).join(", "),
            discussion: (fields[:flarum_discussion_id].data_present?) ? "✔" : "•",
            published: (published) ? "✔" : "•",
            recording_date: fields[:recording_date],
            publish_date: fields[:publish_date],
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Accessors

        def series
          parent
        end

        def events
          Heracles::Page.
            of_type("event").
            joins(:insertions).
            visible.
            published.
            where(
              :"insertions.field" => "podcast_episodes",
              :"insertions.inserted_key" => insertion_key
            )
        end

        def people
          if fields[:people].data_present?
            fields[:people].pages.visible.published
          end
        end

        def audio_version
          if fields[:audio].data_present?
            fields[:audio].assets.first.versions.include?("audio_mp3") ? "audio_mp3" : "original"
          end
        end

        def audio_result
          if fields[:audio].data_present?
            fields[:audio].assets.first.processed_asset.data["versions"][audio_version.to_s]
          end
        end

        def audio_url
          if fields[:audio].data_present?
            fields[:audio].assets.first.send(:"#{audio_version}_url")
          end
        end

        def video_version
          if fields[:video].data_present?
            fields[:video].assets.first.versions.include?(:ipad_high) ? :ipad_high : :original
          end
        end

        def video_result
          if fields[:video].data_present?
            fields[:video].assets.first.processed_asset.data["versions"][video_version.to_s]
          end
        end

        def video_url
          if fields[:video].data_present?
            fields[:video].assets.first.send(:"#{video_version}_url")
          end
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

          date :publish_date do
            fields[:publish_date].value
          end

          time :publish_date_time do
            fields[:publish_date].value
          end

          string :audio_id do
            if fields[:audio].data_present?
              fields[:audio].assets.first.id
            end
          end

          string :video_id do
            if fields[:video].data_present?
              fields[:video].assets.first.id
            end
          end

          time :date_sort_field do
            fields[:publish_date].value
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
