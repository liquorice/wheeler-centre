posts = page.events(page: params[:page], per_page: params[:per_page]).results

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:media" => "http://www.rssboard.org/media-rss", "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/", :version => "2.0" do
  xml.channel do
    xml.title "Events from The Wheeler Centre"
    xml.link url_with_domain(blog_page.absolute_url)
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
        xml.item do
          xml.title post.title
          xml.link url_with_domain(post.absolute_url)
          xml.guid page.id
          if post.fields[:start_date].data_present?
            xml.pubDate post.fields[:start_date].value.rfc2822
          end
          xml.description do
            xml.cdata! render_content post.fields[:body]
          end
          if post.presenters.present?
            xml.author post.presenters.map(&:title).to_sentence
          end
        end
      end
    end
  end
end