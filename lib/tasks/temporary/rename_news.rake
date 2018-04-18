namespace :temporary do
  desc "Rename notes -> news and remove duplicates"
  task rename_news: :environment do
    site = Heracles::Site.first
    # Change notes page to "news"
    blog_page = Heracles::Sites::WheelerCentre::Blog.first
    blog_page.slug = "news"
    blog_page.title = "News"
    blog_page.save!

    Heracles::Site.first.pages.of_type("blog_post").tagged_with("notes").destroy_all
  end
end
