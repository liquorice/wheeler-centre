# Copied from `Heracles::ImageInsertableRenderer, but updated to allow
# markdown rendering of captions.
module Heracles
  module Sites
    module WheelerCentre
      class ImageInsertableRenderer < ::Heracles::ImageInsertableRenderer
        include ActionView::Helpers::TagHelper

        def initialize(insertable_data={}, options={})
          @insertable_data = insertable_data.with_indifferent_access
          @options = options.with_indifferent_access

          @asset = options[:site].assets.images.find_by_id(@insertable_data[:asset_id])
        end

        def render
          # Render nothing if the asset wasn't found
          return "" unless @asset

          small_version_name  = :content_small
          medium_version_name = :content_medium
          large_version_name =  :content_large
          small_version_name  = :original unless @asset.versions.include?(:content_small)
          medium_version_name = :original unless @asset.versions.include?(:content_medium)

          aspect_class = if @asset.file_meta["aspect_ratio"] > 1.333333
            "figure__image--landscape"
          else
            "figure__image--portrait"
          end

          ie9_leader = "<!--[if IE 9]><video style='display: none;'><![endif]-->".html_safe
          ie9_trailer = "<!--[if IE 9]></video><![endif]-->".html_safe
          large_source  = content_tag :source, nil, {srcset: @asset.send(:"#{large_version_name}_url"), media: "(min-width: 1200px)"}
          medium_source = content_tag :source, nil, {srcset: @asset.send(:"#{medium_version_name}_url"), media: "(min-width: 640px)"}
          default_image = content_tag :img, nil, {src: @asset.send(:"#{small_version_name}_url"), alt: @insertable_data[:alt_text], class: "figure__content"}

          # Assemble!
          output = []
          output << content_tag(:picture, [ie9_leader, large_source, medium_source, ie9_trailer, default_image].join.html_safe)

          if @insertable_data[:caption].present? || (@insertable_data[:show_attribution] && @asset.attribution.present?)
            caption_text = ""
            if @insertable_data[:caption].present?
              caption_text += @insertable_data[:caption]
              if @insertable_data[:show_attribution] && @asset.attribution.present?
                caption_text += " — "
              end
            end
            if @insertable_data[:show_attribution] && @asset.attribution.present?
              caption_text += @asset.attribution
            end
            output << content_tag(:div, content_tag(:p, caption_text), class: "figure__caption copy")
          end

          content_tag :div, output.join.html_safe, {class: "figure figure__display--#{(@insertable_data[:display].present? ? @insertable_data[:display] : "default").downcase} #{aspect_class}", style: ("width:#{@insertable_data[:width]}" if @insertable_data[:width])}
        end
      end
    end
  end
end
