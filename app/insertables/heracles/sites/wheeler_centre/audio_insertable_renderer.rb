module Heracles
  module Sites
    module WheelerCentre
      class AudioInsertableRenderer < ::Heracles::AudioInsertableRenderer
        include Rails.application.routes.url_helpers

        ### Helpers

        helper_method \
        def mp3_tracking_url
          if mp3_version
            url = asset.send(:"#{mp3_version[:name]}_url")
            path = File.path(url)
            file_name = File.basename(url)
            track_event_path({
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
            track_event_path({
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

      end
    end
  end
end
