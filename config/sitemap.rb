require 'sitemap_generator'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://#{ENV['CANONICAL_DOMAIN']}"

# Store the sitemap on s3
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['ASSETS_AWS_BUCKET']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path   = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter       = SitemapGenerator::S3Adapter.new(:aws_access_key_id => ENV['ASSETS_AWS_ACCESS_KEY_ID'],
                                                                          :aws_secret_access_key => ENV['ASSETS_AWS_SECRET_ACCESS_KEY'],
                                                                          :fog_provider => ENV['FOG_PROVIDER'],
                                                                          :fog_directory => ENV['ASSETS_AWS_BUCKET'],
                                                                          :fog_region => ENV['ASSETS_AWS_REGION'])

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  def main_app
    Rails.application.class.routes.url_helpers
  end

  # Add blog to index
  blog = Heracles::Sites::WheelerCentre::Blog.published
  blog.each { |p| add "/#{p.url}" }

  # Add blog posts
  blog_posts = Heracles::Sites::WheelerCentre::BlogPost.published
  blog_posts.each { |p| add "/#{p.url}" }

  book_reviews = Heracles::Sites::WheelerCentre::BookReview.published
  book_reviews.each { |p| add "/#{p.url}" }

  broadcasts = Heracles::Sites::WheelerCentre::Broadcasts.published
  broadcasts.each { |p| add "/#{p.url}" }

  # Add all content pages to the sitemap
  pages = Heracles::Sites::WheelerCentre::ContentPage.published
  pages.each { |p| add "/#{p.url}" }

  criticism_now = Heracles::Sites::WheelerCentre::CriticismNow.published
  criticism_now.each { |p| add "/#{p.url}" }

  # Add events to sitemap
  events = Heracles::Sites::WheelerCentre::Event.published
  events.each { |p| add "/#{p.url}" }

  # Add events index
  events_index = Heracles::Sites::WheelerCentre::Events.published
  events_index.each { |p| add "/#{p.url}" }

  # Add events series to sitemap
  events_series = Heracles::Sites::WheelerCentre::EventSeries.published
  events_series.each { |p| add "/#{p.url}" }

  # Add events series indicies to sitemap
  events_series_indicies = Heracles::Sites::WheelerCentre::EventSeriesIndex.published
  events_series_indicies.each { |p| add "/#{p.url}" }

  guests = Heracles::Sites::WheelerCentre::Guests.published
  guests.each { |p| add "/#{p.url}" }

  # Home  - n/a
  # Itunes category - n/a

  # Add people index
  people = Heracles::Sites::WheelerCentre::People.published
  people.each { |p| add "/#{p.url}"}

  # Add persons ;)
  persons = Heracles::Sites::WheelerCentre::Person.published
  persons.each { |p| add "/#{p.url}" }

  # Placeholder n/a

  podcast_episodes = Heracles::Sites::WheelerCentre::PodcastEpisode.published
  podcast_episodes.each { |p| add "/#{p.url}"}

  podcast_series = Heracles::Sites::WheelerCentre::PodcastSeries.published
  podcast_series.each { |p| add "/#{p.url}"}

  podcasts = Heracles::Sites::WheelerCentre::Podcasts.published
  podcasts.each { |p| add "/#{p.url}"}

  presenters = Heracles::Sites::WheelerCentre::Presenters.published
  presenters.each { |p| add "/#{p.url}"}

  recordings = Heracles::Sites::WheelerCentre::Recording.published
  recordings.each { |p| add "/#{p.url}"}

  residents = Heracles::Sites::WheelerCentre::Resident.published
  residents.each { |p| add "/#{p.url}"}

  responses = Heracles::Sites::WheelerCentre::Response.published
  responses.each { |p| add "/#{p.url}"}

  reviews = Heracles::Sites::WheelerCentre::Review.published
  reviews.each { |p| add "/#{p.url}"}

  # Settings n/a

  sponsors = Heracles::Sites::WheelerCentre::Sponsor.published
  sponsors.each { |p| add "/#{p.url}"}

  sponsors_index = Heracles::Sites::WheelerCentre::Sponsors.published
  sponsors_index.each { |p| add "/#{p.url}"}

  texts = Heracles::Sites::WheelerCentre::TextsInTheCity.published
  texts.each { |p| add "/#{p.url}"}

  texts_books = Heracles::Sites::WheelerCentre::TextsInTheCityBook.published
  texts_books.each { |p| add "/#{p.url}"}

  topics = Heracles::Sites::WheelerCentre::Topic.published
  topics.each { |p| add "/#{p.url}"}

  topics_index = Heracles::Sites::WheelerCentre::Topics.published
  topics_index.each { |p| add "/#{p.url}"}

  venues = Heracles::Sites::WheelerCentre::Venue.published
  venues.each { |p| add "/#{p.url}"}

  venues_index = Heracles::Sites::WheelerCentre::Venues.published
  venues_index.each { |p| add "/#{p.url}"}

  vpla_books = Heracles::Sites::WheelerCentre::VplaBook.published
  vpla_books.each { |p| add "/#{p.url}"}

  vpla_categories = Heracles::Sites::WheelerCentre::VplaCategory.published
  vpla_categories.each { |p| add "/#{p.url}"}

  vpla_year = Heracles::Sites::WheelerCentre::VplaYear.published
  vpla_year.each { |p| add "/#{p.url}"}

  zoo_fellowships = Heracles::Sites::WheelerCentre::ZooFellowships.published
  zoo_fellowships.each { |p| add "/#{p.url}"}

  zoo_fellowships_work = Heracles::Sites::WheelerCentre::ZooFellowshipsWork.published
  zoo_fellowships_work.each { |p| add "/#{p.url}"}

end
