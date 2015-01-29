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
              {name: :topics, type: :associated_pages, page_type: :topic},
            ]
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

        def audio_mp3_version
          fields[:audio].asset.results["audio_mp3"]
        end

        searchable do
          string :topic_ids, multiple: true do
            fields[:topics].pages.map(&:id)
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
        end
      end
    end
  end
end
