def build_category_tree(xml, categories)
  categories.map do |category|
    xml.itunes :category, text: category[:category].title do
      build_category_tree xml, category[:children] if category[:children].any?
    end
  end
end

episodes = page.episodes(per_page: 1000).results

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:media" => "http://www.rssboard.org/media-rss", "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/", :version => "2.0" do
  xml.channel do
    xml.title page.title
    xml.link url_with_domain(page.absolute_url)
    xml.lastBuildDate episodes.first.fields[:publish_date].value.rfc2822 if episodes.any?
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
    xml.itunes :image, href: page.fields[:itunes_image].asset.itunes_url if page.fields[:itunes_image].data_present?
    if episodes.any?
      episodes.each do |episode|
        # Let the series explicit value override episode one
        explicit = episode.fields[:explicit].value || page.fields[:explicit].value
        image = if page.fields[:itunes_image].data_present?
          episode.fields[:itunes_image].asset.itunes_url
        elsif page.fields[:itunes_image].data_present?
          page.fields[:itunes_image].asset.itunes_url
        end
        xml.item do
          xml.title episode.title
          xml.dc :creator, (episode.fields[:people].data_present? ? episode.fields[:people].pages.map {|person| person.title} : "The Wheeler Centre")
          xml.pubDate episode.fields[:publish_date].value.rfc2822
          xml.link url_with_domain(episode.absolute_url)
          xml.guid episode.id, isPermaLink: "false"
          xml.description do
            xml.cdata! render_content episode.fields[:description]
          end
          xml.itunes :author, "The Wheeler Centre"
          xml.itunes :summary, episode.fields[:itunes_summary].value
          xml.itunes :explicit, human_boolean(explicit)
          xml.itunes :duration, duration_to_hms(episode.fields[:audio].asset["file_meta"]["duration"])
          xml.itunes :image, href: image if image
          xml.enclosure url: episode.fields[:audio].asset.audio_mp3_url, length: episode.audio_mp3_version["size"], type: "audio/mpeg"
        end
      end
    end
  end
end
