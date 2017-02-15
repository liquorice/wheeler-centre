def build_category_tree(xml, categories)
  categories.map do |category|
    xml.itunes :category, text: category[:category].title do
      build_category_tree xml, category[:children] if category[:children].present?
    end
  end
end

type = (params[:type] == "video") ? "video" : "audio"
episodes = page.episodes(type: type, per_page: 100).results
series_image_url = if page.fields[:itunes_image].data_present?
  version = :original
  version = :itunes if page.fields[:itunes_image].asset.versions.include?(:itunes)
  page.fields[:itunes_image].asset.send(:"#{version}_url")
end

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:media" => "http://www.rssboard.org/media-rss", "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/", :version => "2.0" do
  xml.channel do
    xml.title page.title
    xml.link url_with_domain(page.absolute_url)
    xml.lastBuildDate episodes.first.fields[:publish_date].value.rfc2822 if episodes.present?
    xml.language "en-AU"

    build_category_tree xml, page.itunes_categories

    xml.itunes :author, "The Wheeler Centre"
    xml.itunes :subtitle, page.fields[:itunes_subtitle].value
    xml.itunes :summary, page.fields[:itunes_summary].value
    xml.description page.fields[:itunes_description].value
    xml.itunes :explicit, human_boolean(page.fields[:explicit].value)
    xml.itunes :keywords, page.fields[:itunes_keywords].value
    xml.itunes :owner do
      xml.itunes :name, "The Wheeler Centre"
      xml.itunes :email, "webmaster@wheelercentre.com"
    end
    xml.itunes :category, text: "Technology"
    xml.itunes :image, href: series_image_url if series_image_url.present?
    if episodes.present?
      episodes.each do |episode|
        cache ["podcast-episode-9", page, episode, episode.fields[:people].pages, type, episode.audio_result, episode.video_result, episode.fields[:itunes_image].asset] do
          # Let the series explicit value override episode one
          explicit = episode.fields[:explicit].value || page.fields[:explicit].value
          episode_image_url = if episode.fields[:itunes_image].data_present?
            version = :original
            version = :itunes_url if episode.fields[:itunes_image].asset.versions.include?(:itunes_url)
            episode.fields[:itunes_image].asset.send(:"#{version}_url")
          end
          xml.item do
            xml.title episode.title
            xml.dc :creator, (episode.fields[:people].data_present? ? episode.fields[:people].pages.map {|person| person.title}.to_sentence : "The Wheeler Centre")
            if episode.fields[:publish_date].data_present?
              xml.pubDate episode.fields[:publish_date].value.rfc2822
            else
              xml.pubDate episode.created_at.rfc2822
            end
            xml.link url_with_domain(episode.absolute_url)
            xml.guid episode.id, isPermaLink: "false"
            xml.description do
              content = render_content episode.fields[:description]
              # Add tracking pixels
              content += image_tag(track_pageview_for_page(episode, {format: "image"}), alt: "", width: 1, height: 1)
              content += image_tag(track_event_for_page(episode, {format: "image", category: "podcast", action: "episode - read", label: "#{page.title}: #{episode.title}"}), alt: "", width: 1, height: 1)
              xml.cdata! content
            end
            xml.itunes :author, "The Wheeler Centre"
            xml.itunes :summary, episode.fields[:itunes_summary].value
            xml.itunes :explicit, human_boolean(explicit)
            xml.itunes :image, href: episode_image_url if episode_image_url.present?
            if type == "video"
              duration = episode.video_result["meta"]["duration"] if episode.video_result["meta"].present? && episode.video_result["meta"]["duration"].present?
              xml.itunes :duration, duration_to_hms(duration || 0)
              tracking_url = track_event(episode.video_url, {
                category: "podcast",
                action: "episode - accessed-file",
                label: "#{page.title}: #{episode.title}, #{url_basename(episode.video_url)}",
                format: "video",
                redirect: 301
              })
              xml.enclosure url: tracking_url, length: episode.video_result["size"], type: "video/m4a"
            else
              duration = if episode.audio_result["meta"] && episode.audio_result["meta"]["duration"].present?
                episode.audio_result["meta"]["duration"]
              else
                0
              end
              xml.itunes :duration, duration_to_hms(duration)
              tracking_url = track_event(episode.audio_url, {
                category: "podcast",
                action: "episode - accessed-file",
                label: "#{page.title}: #{episode.title}, #{url_basename(episode.audio_url)}",
                format: "audio",
                redirect: 301
              })
              xml.enclosure url: tracking_url, length: episode.audio_result["size"], type: "audio/mpeg"
            end
          end
        end
      end
    end
  end
end
