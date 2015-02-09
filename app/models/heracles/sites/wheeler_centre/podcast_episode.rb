module Heracles
  module Sites
    module WheelerCentre
      class PodcastEpisode < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :description, type: :content},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :recording_date, type: :date_time, label: "Recording date"},
              # Asset
              {name: :asset_info, type: :info, text: "<hr/>"},
              {name: :video, type: :asset, asset_file_type: :video},
              {name: :audio, type: :asset, asset_file_type: :audio},
              # iTunes
              {name: :itunes_info, type: :info, text: "<hr/>"},
              {name: :itunes_summary, type: :text},
              {name: :itunes_image, type: :asset, asset_file_type: :image},
              {name: :explicit, type: :boolean, defaults: {value: false}, question_text: "Mark episode as explicit?"},
              # Associations
              {name: :assoc_info, type: :info, text: "<hr/>"},
              {name: :people, type: :associated_pages, page_type: :person},
              # Extra
              {name: :extra_info, type: :info, text: "<hr/>"},
              {name: :legacy_recording_id, type: :integer, label: "Legacy recording ID"},
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            people: fields[:people].pages.map(&:title).join(", "),
            video: (fields[:video].data_present?) ? "✔" : "×",
            audio: (fields[:audio].data_present?) ? "♫" : "×",
            recording_date: fields[:recording_date],
            published: (published) ? "✔" : "•",
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Accessors

        def events
          if fields[:events].data_present?
            fields[:events].pages
          end
        end

        def people
          if fields[:people].data_present?
            fields[:people].pages
          end
        end

        def audio_version
          if fields[:audio].data_present?
            fields[:audio].asset.versions.include?(:audio_mp3) ? :audio_mp3 : :original
          end
        end

        def audio_result
          if fields[:audio].data_present?
            fields[:audio].asset.results[audio_version.to_s]
          end
        end

        def audio_url
          if fields[:audio].data_present?
            fields[:audio].asset.send(:"#{audio_version}_url")
          end
        end

        def video_version
          if fields[:video].data_present?
            fields[:video].asset.versions.include?(:ipad_high) ? :ipad_high : :original
          end
        end

        def video_result
          if fields[:video].data_present?
            fields[:video].asset.results[video_version.to_s]
          end
        end

        def video_url
          if fields[:video].data_present?
            fields[:video].asset.send(:"#{video_version}_url")
          end
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
          end

          string :topic_titles, multiple: true do
            fields[:topics].pages.map(&:title)
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
              fields[:audio].asset.id
            end
          end

          string :video_id do
            if fields[:video].data_present?
              fields[:video].asset.id
            end
          end
        end
      end
    end
  end
end
