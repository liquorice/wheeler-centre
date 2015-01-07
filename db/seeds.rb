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
user.save!

# Build the Heracles site
site = Heracles::Site.find_or_initialize_by(slug: HERACLES_SITE_SLUG)
site.title = "Wheeler Centre"
site.hostnames = ["localhost", "wheeler-centre.herokuapp.com"]
site.published = true
site.transloadit_params = {
  "steps" => {
    "content_thumbnail_resized" => {
      "robot"   => "/image/resize",
      "use"     => ":original",
      "width"   => 300,
      "height"  => 300,
      "quality" => 75,
      "resize_strategy" => "fillcrop",
      "gravity" => "center",
      "zoom"    => true,
      "strip"   => true,
    },
    "content_thumbnail" => {
      "robot"   => "/image/optimize",
      "use"     => ["content_thumbnail_resized"],
    },
    "content_small_resized" => {
      "robot"   => "/image/resize",
      "use"     => ":original",
      "width"   => 480,
      "height"  => 720,
      "quality" => 75,
      "zoom"    => false,
      "strip"   => true,
    },
    "content_small" => {
      "robot"   => "/image/optimize",
      "use"     => ["content_small_resized"],
    },
    "content_medium_resized" => {
      "robot"   => "/image/resize",
      "use"     => ":original",
      "width"   => 960,
      "height"  => 960,
      "quality" => 75,
      "zoom"    => false,
      "strip"   => true,
    },
    "content_medium" => {
      "robot"   => "/image/optimize",
      "use"     => ["content_medium_resized"],
    },
    "content_large_resized" => {
      "robot"   => "/image/resize",
      "use"     => ":original",
      "width"   => 1400,
      "height"  => 1400,
      "quality" => 75,
      "zoom"    => false,
      "strip"   => true,
    },
    "content_large" => {
      "robot"   => "/image/optimize",
      "use"     => ["content_large_resized"],
    },
    "store" => {
      "use" => ["content_thumbnail", "content_small", "content_medium", "content_large"],
    }
  }
}
site.save!

# Homepage
homepage = Heracles::Sites::WheelerCentre::HomePage.find_or_initialize_by(url: "home")
homepage.site = site
homepage.title = "Home"
homepage.slug = "home"
homepage.published = true
homepage.locked = true
homepage.page_order_position = :first
homepage.save!

# Events index page
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

# Writings index page
blog_index = Heracles::Sites::WheelerCentre::Blog.find_or_initialize_by(url: "writings")
blog_index.site = site
blog_index.title = "Writings"
blog_index.slug = "writings"
blog_index.published = true
blog_index.locked = true
blog_index.page_order_position = :last
blog_index.save!

# Writings collection
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

# People page
people = Heracles::Sites::WheelerCentre::People.find_or_initialize_by(url: "people")
people.site = site
people.title = "People"
people.slug = "people"
people.published = true
people.locked = true
people.page_order_position = :last
people.save!

# People collection
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

# Sponsors page
sponsors = Heracles::Sites::WheelerCentre::Sponsors.find_or_initialize_by(url: "sponsors")
sponsors.site = site
sponsors.title = "Sponsors"
sponsors.slug = "sponsors"
sponsors.published = true
sponsors.locked = true
sponsors.page_order_position = :last
sponsors.save!

# Sponsors collection
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

# About us
about_us = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us")
about_us.site = site
about_us.title = "About us"
about_us.slug = "about-us"
about_us.published = true
about_us.locked = false
about_us.page_order_position = :last
about_us.save!

# Residents
residents = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "residents")
residents.site = site
residents.title = "Residents"
residents.slug = "residents"
residents.published = true
residents.locked = false
residents.page_order_position = :last
residents.save!

# Donate
donate = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "donate")
donate.site = site
donate.title = "Donate"
donate.slug = "donate"
donate.published = true
donate.locked = false
donate.page_order_position = :last
donate.save!
