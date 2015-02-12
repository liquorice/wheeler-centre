posts = page.posts(page: params[:page], per_page: params[:per_page]).results

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:media" => "http://www.rssboard.org/media-rss", "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/", :version => "2.0" do
  xml.channel do
    xml.title blog_page.title
    xml.link url_with_domain(blog_page.absolute_url)
    xml.lastBuildDate posts.first.fields[:publish_date].value.rfc2822 if posts.present?
    xml.language "en-AU"
    xml.description "Notes from The Wheeler Centre"
    if posts.present?
      posts.each do |post|
        xml.item
          content = render_content post.fields[:intro]
          content += render_content post.fields[:body]
          content += render_content post.fields[:meta]

          xml.title post.title
          xml.link url_with_domain(post.absolute_url)
          xml.guid page.id
          if post.fields[:publish_date].data_present?
            xml.pubDate post.fields[:publish_date].value.rfc2822
          else
            xml.pubDate post.created_at.rfc2822
          end
          xml.description do
            xml.cdata! content
          end
      end
    end
  end
end
