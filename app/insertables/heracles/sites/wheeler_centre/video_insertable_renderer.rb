module Heracles
  module Sites
    module WheelerCentre
      class VideoInsertableRenderer < ::Heracles::VideoInsertableRenderer
        include ActionView::Helpers::TagHelper
        include ActionView::Context

        def initialize(insertable_data={}, options={})
          @insertable_data = insertable_data.with_indifferent_access
          @options = options.with_indifferent_access

          @video = @insertable_data["url"]
        end

        def render
          # Render nothing if the video or it's embed data aren't present
          return "" unless @video && @insertable_data["embedData"].present?

          # ratio = @insertable_data["embedData"]["height"].to_f / @insertable_data["embedData"]["width"].to_f
          # # The ratio is coupled with CSS to make the embed responsive
          # video = content_tag(:div, @insertable_data["embedData"]["html"].html_safe, { class: "responsive-embed", style: "padding-bottom: #{ratio * 100}%" })
          video = content_tag(:div, @insertable_data["embedData"]["html"].html_safe)

          video_cover = content_tag :div, {class: "video-player__cover", "on-click" => "onCoverClick"} do
            metadata = content_tag :div, class: "video-player__metadata" do
              watch    = content_tag :span, "Watch", {class: "video-player__watch"}
              duration = content_tag :span, "", {class: "video-player__duration", "format-duration" => "duration"}
              [watch, duration].join.html_safe
            end

            header = content_tag :div, class: "video-player__header" do
              icon = content_tag :span, nil, class: "video-player__play-icon"
              title = content_tag :h3, @insertable_data["embedData"]["title"], class: "video-player__title"
              [icon, title].join.html_safe
            end

            [header, metadata].join.html_safe
          end


          video_wrapper = content_tag(:div, [video_cover, video].join.html_safe, {class: "video-player {(playing) ? 'video-player--playing' : ''} {(loaded) ? 'video-player--loaded' : ''}", data: {"view-video-player" => true }})
          caption = ""
          if @insertable_data[:caption].present?
            caption = content_tag(:div, content_tag(:p, @insertable_data[:caption]), class: "figure__caption copy")
          end
          content_tag :div, [video_wrapper, caption].join.html_safe, class: "figure figure__video figure__display--#{(@insertable_data[:display] || "default").downcase}"
        end
      end
    end
  end
end
