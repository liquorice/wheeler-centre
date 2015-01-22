module Heracles
  module Sites
    module WheelerCentre
      class VideoInsertableRenderer < ::Heracles::VideoInsertableRenderer

        ### Helpers

        def display_class
          "figure__display--#{(data[:display] || "default").downcase}"
        end
        helper_method :display_class

        def poster_image_url
          poster_url = data[:embedData][:thumbnail_url]
          # Extract the poster image asset
          if @poster_asset
            version_name  = @options[:version].presence || :content_large
            version_name  = :original unless @poster_asset.versions.include?(version_name)
            poster_url    = @poster_asset.send(:"#{version_name.to_sym}_url")
          end
          poster_url
        end
        helper_method :poster_image_url

        def poster_image_aspect_class
          poster_aspect_class = "video-player__poster--landscape"
          if @poster_asset && @poster_asset.file_meta["aspect_ratio"] <= 1.333333
            poster_aspect_class = "video-player__poster--portrait"
          end
          poster_aspect_class
        end
        helper_method :poster_image_aspect_class
      end
    end
  end
end

