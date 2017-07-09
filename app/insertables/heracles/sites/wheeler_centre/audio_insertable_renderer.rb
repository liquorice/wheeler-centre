module Heracles
  module Sites
    module WheelerCentre
      class AudioInsertableRenderer < ::Heracles::AudioInsertableRenderer
        include TrackingHelper

        ### Helpers

        helper_method \
        def mp3_tracking_url
          if mp3_version
            url = mp3_version["url"]
            path = File.path(url)
            file_name = File.basename(url)
            track_event_url({
              target: url,
              location: url,
              path: path,
              category: "audio",
              action: "accessed-file",
              label: "#{title}, #{file_name}"
            })
          end
        end

        helper_method \
        def ogg_tracking_url
          if ogg_version
            url = ogg_version["url"]
            path = File.path(url)
            file_name = File.basename(url)
            track_event_url({
              target: url,
              location: url,
              path: path,
              category: "audio",
              action: "accessed-file",
              label: "#{title}, #{file_name}"
            })
          end
        end

        def display_class
          "figure__display--#{(data[:display] || "default").downcase}"
        end
        helper_method :display_class

        helper_method \
        def mp3_version
          asset.processed_assets.first.versions["audio_mp3"].first
        end

        helper_method \
        def ogg_version
          asset.processed_assets.first.versions["audio_ogg"].first
        end

        def find_version_by_mime_type(mime_type)
          version = nil
          asset.processed_assets.each do |result|
            if result.data["mime"] == mime_type
              version = {
                name: result["name"],
                version: result
              }
            end
          end
          version
        end

      end
    end
  end
end
