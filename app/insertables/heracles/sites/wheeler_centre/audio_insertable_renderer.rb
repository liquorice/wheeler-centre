module Heracles
  module Sites
    module WheelerCentre
      class AudioInsertableRenderer < ::Heracles::AudioInsertableRenderer
        include TrackingHelper

        ### Helpers

        helper_method \
        def mp3_tracking_url
          if mp3_version
            url = asset.send(:"#{mp3_version[:name]}_url")
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
            url = asset.send(:"#{ogg_version[:name]}_url")
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
          find_version_by_mime_type "audio/mpeg"
        end

        helper_method \
        def ogg_version
          find_version_by_mime_type "audio/x-ogg"
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
