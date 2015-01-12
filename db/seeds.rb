# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Make an admin user for Heracles
user = Heracles::User.find_or_initialize_by(email: "hello@icelab.com.au")
user.password = "password1"
user.name = "icelab"
user.save!
user.update(superadmin: true)

# Make an admin user for Jon
user = Heracles::User.find_or_initialize_by(email: "jon.tjhia@wheelercentre.com")
user.password = "bawt6Aik6uS5eW"
user.name = "Jon Tjhia"
user.save!

# Build the Heracles site
site = Heracles::Site.find_or_initialize_by(slug: HERACLES_SITE_SLUG)
site.title = "Wheeler Centre"
site.hostnames = ["localhost:5000", "wheeler-centre.herokuapp.com"]
site.published = true
site.transloadit_params = {
  "steps"=> {
    "content_thumbnail_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 300,
      "height"=> 300,
      "quality"=> 75,
      "resize_strategy"=> "fillcrop",
      "gravity"=> "center",
      "zoom"=> true,
      "strip"=> true
    },
    "content_thumbnail"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_thumbnail_resized"]
    },
    "content_small_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 480,
      "height"=> 720,
      "quality"=> 75,
      "zoom"=> false,
      "strip"=> true
    },
    "content_small"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_small_resized"]
    },
    "content_medium_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 960,
      "height"=> 960,
      "quality"=> 75,
      "zoom"=> false,
      "strip"=> true
    },
    "content_medium"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_medium_resized"]
    },
    "content_large_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 1400,
      "height"=> 1400,
      "quality"=> 75,
      "zoom"=> false,
      "strip"=> true
    },
    "content_large"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_large_resized"]
    },
    "content_large_thumbnail_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 1400,
      "height"=> 800,
      "quality"=> 75,
      "resize_strategy"=> "crop",
      "gravity"=> "center",
      "zoom"=> true,
      "strip"=> true
    },
    "content_large_thumbnail"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_large_thumbnail_resized"]
    },
    "content_medium_thumbnail_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 960,
      "height"=> 550,
      "quality"=> 75,
      "resize_strategy"=> "crop",
      "gravity"=> "center",
      "zoom"=> true,
      "strip"=> true
    },
    "content_medium_thumbnail"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_medium_thumbnail_resized"]
    },
    "content_small_thumbnail_resized"=> {
      "robot"=> "/image/resize",
      "use"=> ":original",
      "width"=> 480,
      "height"=> 274,
      "quality"=> 75,
      "resize_strategy"=> "crop",
      "gravity"=> "center",
      "zoom"=> true,
      "strip"=> true
    },
    "content_small_thumbnail"=> {
      "robot"=> "/image/optimize",
      "use"=> ["content_small_thumbnail_resized"]
    },
    "store"=> {
      "use"=> ["content_thumbnail", "content_small", "content_medium", "content_large", "content_small_thumbnail", "content_medium_thumbnail", "content_large_thumbnail"]
    }
  }
}
site.save!

# Homepage
# ------------------------------------------------------------------------------
homepage = Heracles::Sites::WheelerCentre::HomePage.find_or_initialize_by(url: "home")
homepage.site = site
homepage.title = "Home"
homepage.slug = "home"
homepage.published = true
homepage.locked = true
homepage.page_order_position = :first
homepage.save!

# Events
# ------------------------------------------------------------------------------
events_index = Heracles::Sites::WheelerCentre::EventsIndex.find_or_initialize_by(url: "events")
events_index.site = site
events_index.title = "Events"
events_index.slug = "events"
events_index.published = true
events_index.locked = true
events_index.page_order_position = :last
events_index.save!

# Events collection
events_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/all-events")
events_collection.parent = events_index
events_collection.site = site
events_collection.title = "All Events"
events_collection.slug = "all-events"
events_collection.fields[:contained_page_type].value = "event"
events_collection.fields[:sort_attribute].value = "created_at"
events_collection.fields[:sort_direction].value = "DESC"
events_collection.published = false
events_collection.locked = true
events_collection.page_order_position = :last
events_collection.save!

# Events series collection
events_series_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/all-event-series")
events_series_collection.parent = events_index
events_series_collection.site = site
events_series_collection.title = "All Event Series"
events_series_collection.slug = "all-event-series"
events_series_collection.fields[:contained_page_type].value = "event_series"
events_series_collection.fields[:sort_attribute].value = "created_at"
events_series_collection.fields[:sort_direction].value = "DESC"
events_series_collection.published = false
events_series_collection.locked = true
events_series_collection.page_order_position = :last
events_series_collection.save!

# Writings
# ------------------------------------------------------------------------------
blog_index = Heracles::Sites::WheelerCentre::Blog.find_or_initialize_by(url: "writings")
blog_index.site = site
blog_index.title = "Writings"
blog_index.slug = "writings"
blog_index.published = true
blog_index.locked = true
blog_index.page_order_position = :last
blog_index.save!

# Writings -> Writings collection
blog_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "writings/all-writings")
blog_collection.parent = blog_index
blog_collection.site = site
blog_collection.title = "All Writings"
blog_collection.slug = "all-writings"
blog_collection.fields[:contained_page_type].value = "blog_post"
blog_collection.fields[:sort_attribute].value = "created_at"
blog_collection.fields[:sort_direction].value = "DESC"
blog_collection.published = false
blog_collection.locked = true
blog_collection.page_order_position = :last
blog_collection.save!

# Broadcasts index page
# ------------------------------------------------------------------------------
broadcasts_index = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "broadcasts")
broadcasts_index.site = site
broadcasts_index.title = "Broadcasts"
broadcasts_index.slug = "broadcasts"
broadcasts_index.published = true
broadcasts_index.locked = true
broadcasts_index.page_order_position = :last
broadcasts_index.save!

# Broadcasts -> Recordings collection
recordings_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "broadcasts/all-recordings")
recordings_collection.parent = broadcasts_index
recordings_collection.site = site
recordings_collection.title = "All Recordings"
recordings_collection.slug = "all-recordings"
recordings_collection.fields[:contained_page_type].value = "recording"
recordings_collection.fields[:sort_attribute].value = "created_at"
recordings_collection.fields[:sort_direction].value = "DESC"
recordings_collection.published = false
recordings_collection.locked = true
recordings_collection.page_order_position = :last
recordings_collection.save!

# Broadcasts -> Podcasts
podcasts = Heracles::Sites::WheelerCentre::Podcasts.find_or_initialize_by(url: "podcasts")
podcasts.site = site
podcasts.parent = broadcasts_index
podcasts.title = "Podcasts"
podcasts.slug = "podcasts"
podcasts.published = true
podcasts.locked = true
podcasts.page_order_position = :last
podcasts.save!

# People page
# ------------------------------------------------------------------------------
people = Heracles::Sites::WheelerCentre::People.find_or_initialize_by(url: "people")
people.site = site
people.title = "People"
people.slug = "people"
people.published = true
people.locked = true
people.page_order_position = :last
people.save!

# People -> People collection
people_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "people/all-people")
people_collection.parent = people
people_collection.site = site
people_collection.title = "All People"
people_collection.slug = "all-people"
people_collection.fields[:contained_page_type].value = "person"
people_collection.fields[:sort_attribute].value = "created_at"
people_collection.fields[:sort_direction].value = "DESC"
people_collection.published = false
people_collection.locked = true
people_collection.page_order_position = :last
people_collection.save!


# About us
# ------------------------------------------------------------------------------
about_us = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us")
about_us.site = site
about_us.title = "About us"
about_us.slug = "about-us"
about_us.published = true
about_us.locked = false
about_us.page_order_position = :last
about_us.save!

# About us -> Who we are
who = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "who-we-are")
who.site = site
who.parent = about_us
who.title = "Who we are"
who.slug = "who-we-are"
who.published = true
who.locked = false
who.page_order_position = :last
who.save!

# About us -> Who funds us
funds = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "who-funds-us")
funds.site = site
funds.parent = about_us
funds.title = "Who funds us"
funds.slug = "who-funds-us"
funds.published = true
funds.locked = false
funds.page_order_position = :last
funds.save!

# About us -> Who funds us -> Support us
support_us = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "support-us")
support_us.site = site
support_us.parent = funds
support_us.title = "Support us"
support_us.slug = "support-us"
support_us.published = true
support_us.locked = false
support_us.page_order_position = :last
support_us.save!

# About us -> Who funds us -> Sponsors
sponsors = Heracles::Sites::WheelerCentre::Sponsors.find_or_initialize_by(url: "sponsors")
sponsors.site = site
sponsors.parent = funds
sponsors.title = "Sponsors"
sponsors.slug = "sponsors"
sponsors.published = true
sponsors.locked = true
sponsors.page_order_position = :last
sponsors.save!

# About us -> Who funds us -> Sponsors -> Sponsors collection
sponsors_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "sponsors/all-sponsors")
sponsors_collection.parent = sponsors
sponsors_collection.site = site
sponsors_collection.title = "All sponsors"
sponsors_collection.slug = "all-sponsors"
sponsors_collection.fields[:contained_page_type].value = "sponsors"
sponsors_collection.fields[:sort_attribute].value = "created_at"
sponsors_collection.fields[:sort_direction].value = "DESC"
sponsors_collection.published = false
sponsors_collection.locked = true
sponsors_collection.page_order_position = :last
sponsors_collection.save!

# About us -> Residents
residents = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "resident-organisations")
residents.site = site
residents.parent = about_us
residents.title = "Resident organisations"
residents.slug = "resident-organisations"
residents.published = true
residents.locked = false
residents.page_order_position = :last
residents.save!

# About us -> Ticketing
ticketing = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "ticketing")
ticketing.site = site
ticketing.parent = about_us
ticketing.title = "Ticketing"
ticketing.slug = "ticketing"
ticketing.published = true
ticketing.locked = false
ticketing.page_order_position = :last
ticketing.save!

# About us -> FAQs
faqs = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "faqs")
faqs.site = site
faqs.parent = about_us
faqs.title = "FAQs"
faqs.slug = "faqs"
faqs.published = true
faqs.locked = false
faqs.page_order_position = :last
faqs.save!

# About us -> Privacy policy
privacy = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "privacy")
privacy.site = site
privacy.parent = about_us
privacy.title = "Privacy policy"
privacy.slug = "privacy"
privacy.published = true
privacy.locked = false
privacy.page_order_position = :last
privacy.save!

# About us -> Community guidelines
community_guidelines = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "community-guidelines")
community_guidelines.site = site
community_guidelines.parent = about_us
community_guidelines.title = "Community guidelines"
community_guidelines.slug = "community-guidelines"
community_guidelines.published = true
community_guidelines.locked = false
community_guidelines.page_order_position = :last
community_guidelines.save!
