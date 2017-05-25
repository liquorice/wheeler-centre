posts = page.posts(page: params[:page], per_page: params[:per_page])

xml.instruct! :xml, :version => "1.0"
xml.rss "xmlns:content" => "http://purl.org/rss/1.0/modules/content/", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "xmlns:atom" => "http://www.w3.org/2005/Atom", :version => "2.0" do
  xml.channel do
    xml.title "Notes from The Wheeler Centre"
    xml.link url_with_domain(blog_page.absolute_url)
    xml.atom :link, href: "#{url_with_domain(page.absolute_url)}.rss", rel: "self", type: "application/rss+xml"
    if posts.present?
      first = posts.first
      if first.fields[:publish_date].data_present?
        xml.lastBuildDate first.fields[:publish_date].value.rfc2822
      else
        xml.lastBuildDate first.created_at.rfc2822
      end
    end
    xml.language "en-AU"
    xml.description "Crib notes, reflections and ephemera from the world of books, writing and ideas."
    if posts.present?
      posts.each do |post|
        cache ["blog-rss-5", post] do
          xml.item do
            content =  replace_absolute_links_with_canonical_domain render_content post.fields[:intro]
            content += replace_absolute_links_with_canonical_domain render_content post.fields[:body]
            content += replace_absolute_links_with_canonical_domain render_content post.fields[:meta]
            # Add tracking pixels
            content += image_tag(track_pageview_for_page(post, {format: "image"}), alt: "", width: 1, height: 1)
            content += image_tag(track_event_for_page(post, {format: "image", category: "rss", action: "read - note"}), alt: "", width: 1, height: 1)

            xml.title post.title
            xml.link url_with_domain(post.absolute_url)
            xml.guid url_with_domain(post.absolute_url)
            if post.fields[:publish_date].data_present?
              xml.pubDate post.fields[:publish_date].value.rfc2822
            else
              xml.pubDate post.created_at.rfc2822
            end
            xml.description do
              xml.cdata! Sanitize.fragment(content, Sanitize::Config::RELAXED)
            end
            if post.fields[:authors].data_present?
              xml.dc :creator, post.fields[:authors].pages.map(&:title).to_sentence
            end
          end
        end
      end
    end
  end
end
