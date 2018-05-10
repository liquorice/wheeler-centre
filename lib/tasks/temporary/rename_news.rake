namespace :temporary do
  desc "Rename notes -> news and remove duplicates"
  task rename_news: :environment do
    site = Heracles::Site.first
    # Change notes page to "news"
    blog_page = Heracles::Sites::WheelerCentre::Blog.first
    blog_page.slug = "news"
    blog_page.title = "News"
    blog_page.save!

    # all notes collection
    all_notes = Heracles::Page.find_by_url("news/all-notes")
    all_notes.title = "All news"
    all_notes.slug = "all-news"
    all_notes.save

    # All our notes page
    archive = Heracles::Page.find_by_url("news/archive")
    archive.title = "All our news"
    archive.fields["nav_title"].value = "News archive"
    archive.save

    # unpublish the duplicates
    Heracles::Site.first.pages.of_type("blog_post").tagged_with("notes").each do |post|
      post.published = false
      post.hidden = true
      post.save
    end

    # new notes -> notes
    longform_blog_page = Heracles::Sites::WheelerCentre::LongformBlog.first
    longform_blog_page.slug = "notes"
    longform_blog_page.title = "Notes"
    longform_blog_page.save!
  end
end
