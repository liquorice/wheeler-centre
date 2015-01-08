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
          @poster_asset = options[:site].assets.images.find_by_id(@insertable_data[:asset_id])
        end

        def render
          # Render nothing if the video or its embed data aren't present
          return "" unless @video && @insertable_data["embedData"].present?

          poster_url = @insertable_data["embedData"]["thumbnail_url"]
          poster_aspect_class = "video-player__poster--landscape"
          # Extract the poster image asset
          if @poster_asset
            version_name  = @options[:version].presence || :content_large
            version_name  = :original unless @poster_asset.versions.include?(version_name)
            poster_url    = @poster_asset.send(:"#{version_name.to_sym}_url")

            poster_aspect_class = if @poster_asset.file_meta["aspect_ratio"] <= 1.333333
              "video-player__poster--portrait"
            end
          end

          ratio = @insertable_data["embedData"]["height"].to_f / @insertable_data["embedData"]["width"].to_f
          # The ratio is coupled with CSS to make the embed responsive
          video = content_tag(:div, @insertable_data["embedData"]["html"].html_safe, { class: "responsive-embed", style: "padding-bottom: #{ratio * 100}%" })
          video_content = content_tag :div, class: "video-player__content" do
            video_content_inner = content_tag :div, video, class: "video-player__content-inner"
            [video_content_inner].join.html_safe
          end

          video_teaser = content_tag :div, {class: "video-player__teaser #{poster_aspect_class if poster_aspect_class}", style: ("background-image: url(#{poster_url})" if poster_url), "on-click" => "onTeaserClick"} do
            cover = content_tag :div, nil, {class: "video-player__cover"}
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

            [cover, header, metadata].join.html_safe
          end


          video_wrapper = content_tag(:div, [video_teaser, video_content].join.html_safe, {class: "video-player {(playing) ? 'video-player--playing' : ''} {(loaded) ? 'video-player--loaded' : ''}", data: {"view-video-player" => true }})
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
