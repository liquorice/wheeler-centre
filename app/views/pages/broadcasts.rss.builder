posts = page.recordings(page: params[:page], per_page: params[:per_page]).results

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:media" => "http://www.rssboard.org/media-rss", "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/", :version => "2.0" do
  xml.channel do
    xml.title "Broadcasts from The Wheeler Centre"
    xml.link url_with_domain(broadcasts_page.absolute_url)
    if posts.present?
      first = posts.first
      if first.fields[:publish_date].data_present?
        xml.lastBuildDate first.fields[:publish_date].value.rfc2822
      else
        xml.lastBuildDate first.created_at.rfc2822
      end
    end
    xml.language "en-AU"
    xml.description "All our events, with online booking."
    if posts.present?
      posts.each do |post|
        cache ["broadcasts-rss-1", post] do
          xml.item do
            description = []
            if post.fields[:youtube_video].data_present?
              description << post.fields[:youtube_video].embed["html"]
            end
            description << replace_absolute_links_with_canonical_domain(render_content(post.fields[:description]))
            # Add tracking pixels
            description << image_tag(track_pageview_for_page(post, {format: "image"}), alt: "")
            description << image_tag(track_event_for_page(post, {format: "image", event_category: "rss", event_action: "read - broadcast"}), alt: "")

            xml.title post.title
            xml.link url_with_domain(post.absolute_url)
            xml.guid page.id

            xml.description do
              xml.cdata! description.join("").html_safe
            end
            if post.people.present?
              xml.author post.people.map(&:title).to_sentence
            end
          end
        end
      end
    end
  end
end
