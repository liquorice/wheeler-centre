posts = page.events(page: params[:page], per_page: params[:per_page]).results

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:media" => "http://www.rssboard.org/media-rss", "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/", :version => "2.0" do
  xml.channel do
    xml.title "Events from The Wheeler Centre"
    xml.link url_with_domain(events_page.absolute_url)
    if posts.present?
      first = posts.first
      if first.fields[:start_date].data_present?
        xml.lastBuildDate first.fields[:start_date].value.rfc2822
      else
        xml.lastBuildDate first.created_at.rfc2822
      end
    end
    xml.language "en-AU"
    xml.description "All our events, with online booking."
    if posts.present?
      posts.each do |post|
        cache ["event-rss-1", post] do
          xml.item do
            content = replace_absolute_links_with_canonical_domain render_content post.fields[:body]
            # Add tracking pixels
            content += image_tag(track_pageview_for_page(post, {format: "image"}), alt: "")
            content += image_tag(track_event_for_page(post, {format: "image", category: "rss", track_action: "read - note"}), alt: "")

            xml.title post.title
            xml.link url_with_domain(post.absolute_url)
            xml.guid page.id
            if post.fields[:start_date].data_present?
              xml.pubDate post.fields[:start_date].value.rfc2822
            end
            xml.description do
              xml.cdata! Sanitize.fragment(content, Sanitize::Config::RELAXED)
            end
            if post.presenters.present?
              xml.author post.presenters.map(&:title).to_sentence
            end
          end
        end
      end
    end
  end
end
