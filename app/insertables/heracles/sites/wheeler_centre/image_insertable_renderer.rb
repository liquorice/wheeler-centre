module Heracles
  module Sites
    module WheelerCentre
      class ImageInsertableRenderer < ::Heracles::ImageInsertableRenderer

        ### Helpers

        def display_class
          "figure__display--#{(data[:display].presence || "default").downcase}"
        end
        helper_method :display_class

        def small_version_url
          version_name  = :content_small
          version_name  = :original unless asset.versions.include?(:content_small)
          asset.send(:"#{version_name.to_sym}_url")
        end
        helper_method :small_version_url

        def medium_version_url
          version_name  = :content_medium
          version_name  = :original unless asset.versions.include?(:content_medium)
          asset.send(:"#{version_name.to_sym}_url")
        end
        helper_method :medium_version_url

        def large_version_url
          version_name  = :content_large
          version_name  = :original unless asset.versions.include?(:content_large)
          asset.send(:"#{version_name.to_sym}_url")
        end
        helper_method :large_version_url

        def aspect_class
          if asset.file_meta["aspect_ratio"].present? && asset.file_meta["aspect_ratio"].to_f <= 1.333333
            "figure__image--portrait"
          else
            "figure__image--landscape"
          end
        end
        helper_method :aspect_class

        def option_class
          options[:class].presence
        end
        helper_method :option_class
      end
    end
  end
end

