posts = page.posts(page: params[:page]).results

atom_feed do |feed|
  feed.title(page.title)
  feed.updated(posts.first.created_at) if posts.length > 0

  posts.each do |post|
    feed.entry(post, url: post.absolute_url) do |entry|
      entry.title(post.title)
      entry.content(render_content(post.fields[:body]), type: "html")

      # entry.author do |author|
      #   author.name("DHH")
      # end
    end
  end
end
