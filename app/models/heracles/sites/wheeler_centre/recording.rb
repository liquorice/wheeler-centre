module Heracles
  module Sites
    module WheelerCentre
      class Recording < ::Heracles::Page
        def self.config
          {
            fields: [
              {name: :short_title, type: :text, label: "Short title"},
              {name: :hero_image, type: :asset, asset_file_type: :image},
              {name: :description, type: :content},
              # Dates
              {name: :dates_info, type: :info, text: "<hr/>"},
              {name: :publish_date, type: :date_time, label: "Publish date"},
              {name: :recording_date, type: :date_time, label: "Recording date"},
              # Asset
              {name: :asset_info, type: :info, text: "<hr/>"},
              {name: :youtube_video, type: :external_video},
              {name: :video_poster_image, type: :asset, asset_file_type: :image},
              {name: :video, type: :asset, asset_file_type: :video, editor_columns: 6},
              {name: :audio, type: :asset, asset_file_type: :audio, editor_columns: 6},
              # Associations
              {name: :assoc_info, type: :info, text: "<hr/>"},
              {name: :people, type: :associated_pages, page_type: :person},
              # Extra
              {name: :extra_info, type: :info, text: "<hr/>"},
              {name: :transcript, type: :content},
              {name: :topics, type: :associated_pages, page_type: :topic},
              {name: :recording_id, type: :integer, label: "Legacy recording ID"},
            ]
          }
        end

        ### Summary

        def to_summary_hash
          {
            title: title,
            video: (fields[:video].data_present?) ? "✔" : "×",
            audio: (fields[:audio].data_present?) ? "♫" : "×",
            youtube_video: fields[:youtube_video].value.presence || "",
            events: events.map(&:title).join(", "),
            people: (people.any? ? "#{people.length} #{(people.length > 1) ? 'people' : 'person'}" : "·"),
            published: (published) ? "✔" : "•",
            recording_date: fields[:recording_date],
            publish_date: fields[:publish_date],
            created_at:  created_at.to_s(:admin_date)
          }
        end

        ### Accessors

        def youtube_thumbnail_url
          if fields[:youtube_video].data_present?
            fields[:youtube_video].youtube["snippet"]["thumbnails"]["high"]["url"]
          end
        end

        def events
          Heracles::Page.
            of_type("event").
            joins(:insertions).
            where(
              :"insertions.field" => "recordings",
              :"insertions.inserted_key" => insertion_key
            )
        end

        def people
          # If there are no people explicitly set on this page, try to infer
          # them from the related event/s
          if fields[:people].data_present?
            fields[:people].pages
          else
            people = []
            events.each {|event| people = people + event.fields[:presenters].pages }
            people
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

          text :youtube_video do
            fields[:youtube_video].value
          end

          date :publish_date do
            fields[:publish_date].value
          end

          time :publish_date_time do
            fields[:publish_date].value
          end

          date :recording_date do
            fields[:recording_date].value
          end

          time :recording_date_time do
            fields[:recording_date].value
          end

        end
      end
    end
  end
end
