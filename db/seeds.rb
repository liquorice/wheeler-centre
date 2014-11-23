# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Make an admin user for Heracles
user = User.find_or_initialize_by(email: "hello@icelab.com.au")
user.password = "password1"
user.save!

# Build the Heracles site
site = Heracles::Site.find_or_initialize_by(slug: HERACLES_SITE_SLUG)
site.title = "Wheeler Centre"
site.hostnames = ["localhost, wheeler-centre.herokuapp.com"]
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