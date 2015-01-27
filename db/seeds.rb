# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Common helpers
def slugify(name)
  name.downcase.gsub(/\&/, "and").gsub(/[^a-zA-Z0-9]/, ' ').gsub(/\s+/, '-')
end

# Make an admin user for Heracles
user = Heracles::User.find_or_initialize_by(email: "hello@icelab.com.au")
user.password = "password1"
user.name = "icelab"
user.save!
user.update(superadmin: true)

# Build the Heracles site
site = Heracles::Site.find_or_initialize_by(slug: HERACLES_SITE_SLUG)
site.title = "Wheeler Centre"
site.hostnames = ["localhost:5000", "wheeler-centre.herokuapp.com"]
site.published = true
site.transloadit_params = {
  "steps" => {
    "content_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 300,
      "height" => 300,
      "quality" => 75,
      "resize_strategy" => "fillcrop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true
    },
    "content_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_thumbnail_resized"]
    },
    "content_small_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 480,
      "height" => 720,
      "quality" => 75,
      "zoom" => false,
      "strip" => true
    },
    "content_small" => {
      "robot" => "/image/optimize",
      "use" => ["content_small_resized"]
    },
    "content_medium_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 960,
      "height" => 960,
      "quality" => 75,
      "zoom" => false,
      "strip" => true
    },
    "content_medium" => {
      "robot" => "/image/optimize",
      "use" => ["content_medium_resized"]
    },
    "content_large_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 1400,
      "height" => 1400,
      "quality" => 75,
      "zoom" => false,
      "strip" => true
    },
    "content_large" => {
      "robot" => "/image/optimize",
      "use" => ["content_large_resized"]
    },
    "content_large_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 1400,
      "height" => 800,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true
    },
    "content_large_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_large_thumbnail_resized"]
    },
    "content_medium_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 960,
      "height" => 550,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true
    },
    "content_medium_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_medium_thumbnail_resized"]
    },
    "content_small_thumbnail_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 480,
      "height" => 274,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true
    },
    "content_small_thumbnail" => {
      "robot" => "/image/optimize",
      "use" => ["content_small_thumbnail_resized"]
    },
    "audio_mp3" => {
      "robot" => "/audio/encode",
      "use" => ":original",
      "preset" => "mp3"
    },
    "audio_ogg" => {
      "robot" => "/audio/encode",
      "use" => ":original",
      "preset" => "ogg"
    },
    "video_ipad_high" => {
      "robot" => "/video/encode",
      "use" => ":original",
      "preset" => "ipad-high"
    },
    "video_iphone_high" => {
      "robot" => "/video/encode",
      "use" => ":original",
      "preset" => "iphone-high"
    },
    "store" => {
      "use" => [
        "content_thumbnail",
        "content_small",
        "content_medium",
        "content_large",
        "content_small_thumbnail",
        "content_medium_thumbnail",
        "content_large_thumbnail",
        "audio_mp3",
        "audio_ogg",
        "video_ipad_high",
        "video_iphone_high"
      ]
    },
    "store_youtube" => {
      "robot" => "/youtube/store",
      "use" => [":original"],
      "username" => "",
      "password" => "",
      "title" => "${file.name}",
      "description" => "${file.name} description",
      "category" => "People & Blogs",
      "keywords" => "Ideas, Melbourne, Australia, Conversation, The Wheeler Centre, Victoria, Writing",
      "visibility" => "private"
    }
  }
}
site.save!

# Make an admin user for Jon
user = Heracles::User.find_or_initialize_by(email: "jon.tjhia@wheelercentre.com")
user.password = "bawt6Aik6uS5eW"
user.name = "Jon Tjhia"
user.sites << site
user.save!

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
events_index = Heracles::Sites::WheelerCentre::Events.find_or_initialize_by(url: "events")
events_index.site = site
events_index.title = "Events"
events_index.slug = "events"
events_index.published = true
events_index.locked = true
events_index.page_order_position = :last if events_index.new_record?
events_index.save!

# Events -> Events collection
events_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/all-events")
events_collection.parent = events_index
events_collection.site = site
events_collection.title = "All Events"
events_collection.slug = "all-events"
events_collection.fields[:contained_page_type].value = :event
events_collection.fields[:sort_attribute].value = "created_at"
events_collection.fields[:sort_direction].value = "DESC"
events_collection.published = false
events_collection.locked = true
events_collection.page_order_position = :last if events_collection.new_record?
events_collection.save!

# Events -> Event series index
events_series_index = Heracles::Sites::WheelerCentre::EventSeriesIndex.find_or_initialize_by(url: "events/series")
events_series_index.site = site
events_series_index.parent = events_index
events_series_index.title = "Series"
events_series_index.slug = "series"
events_series_index.published = true
events_series_index.locked = true
events_series_index.page_order_position = :last if events_series_index.new_record?
events_series_index.save!

# Events -> Event series index -> Event series collection
event_series_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/all-event-series")
event_series_collection.parent = events_series_index
event_series_collection.site = site
event_series_collection.title = "All Event Series"
event_series_collection.slug = "all-event-series"
event_series_collection.fields[:contained_page_type].value = :event_series
event_series_collection.fields[:sort_attribute].value = "created_at"
event_series_collection.fields[:sort_direction].value = "DESC"
event_series_collection.published = false
event_series_collection.locked = true
event_series_collection.page_order_position = :last if event_series_collection.new_record?
event_series_collection.save!

# Events -> Presenters
presenters = Heracles::Sites::WheelerCentre::Presenters.find_or_initialize_by(url: "events/venues")
presenters.site = site
presenters.parent = events_index
presenters.title = "Presenters"
presenters.slug = "presenters"
presenters.published = true
presenters.locked = true
presenters.page_order_position = :last if presenters.new_record?
presenters.save!

# Events -> Venues index
venues_index = Heracles::Sites::WheelerCentre::Venues.find_or_initialize_by(url: "events/venues")
venues_index.site = site
venues_index.parent = events_index
venues_index.title = "Venues"
venues_index.slug = "venues"
venues_index.published = true
venues_index.locked = true
venues_index.page_order_position = :last if venues_index.new_record?
venues_index.save!

# Events -> Venues index -> Venues collection
venues_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/all-event-venues")
venues_collection.parent = venues_index
venues_collection.site = site
venues_collection.title = "All Venues"
venues_collection.slug = "all-event-venues"
venues_collection.fields[:contained_page_type].value = :venues
venues_collection.fields[:sort_attribute].value = "created_at"
venues_collection.fields[:sort_direction].value = "DESC"
venues_collection.published = false
venues_collection.locked = true
venues_collection.page_order_position = :last if venues_collection.new_record?
venues_collection.save!

# Writings
# ------------------------------------------------------------------------------
blog_index = Heracles::Sites::WheelerCentre::Blog.find_or_initialize_by(url: "writings")
blog_index.site = site
blog_index.title = "Writings"
blog_index.slug = "writings"
blog_index.published = true
blog_index.locked = true
blog_index.page_order_position = :last if blog_index.new_record?
blog_index.save!

# Writings -> Writings collection
blog_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "writings/all-writings")
blog_collection.parent = blog_index
blog_collection.site = site
blog_collection.title = "All Writings"
blog_collection.slug = "all-writings"
blog_collection.fields[:contained_page_type].value = :blog_post
blog_collection.fields[:sort_attribute].value = "created_at"
blog_collection.fields[:sort_direction].value = "DESC"
blog_collection.published = false
blog_collection.locked = true
blog_collection.page_order_position = :last if blog_collection.new_record?
blog_collection.save!

# Writings -> Guests
guests = Heracles::Sites::WheelerCentre::Guests.find_or_initialize_by(url: "writings/guests")
guests.site = site
guests.parent = blog_index
guests.title = "Guest authors"
guests.slug = "guests"
guests.published = true
guests.locked = true
guests.page_order_position = :last if guests.new_record?
guests.save!

# Broadcasts index page
# ------------------------------------------------------------------------------
broadcasts_index = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "broadcasts")
broadcasts_index.site = site
broadcasts_index.title = "Broadcasts"
broadcasts_index.slug = "broadcasts"
broadcasts_index.published = true
broadcasts_index.locked = true
broadcasts_index.page_order_position = :last if broadcasts_index.new_record?
broadcasts_index.save!

# Broadcasts -> Recordings collection
recordings_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "broadcasts/all-recordings")
recordings_collection.parent = broadcasts_index
recordings_collection.site = site
recordings_collection.title = "All Recordings"
recordings_collection.slug = "all-recordings"
recordings_collection.fields[:contained_page_type].value = :recording
recordings_collection.fields[:sort_attribute].value = "created_at"
recordings_collection.fields[:sort_direction].value = "DESC"
recordings_collection.published = false
recordings_collection.locked = true
recordings_collection.page_order_position = :last if recordings_collection.new_record?
recordings_collection.save!

# Broadcasts -> Podcasts
podcasts = Heracles::Sites::WheelerCentre::Podcasts.find_or_initialize_by(url: "podcasts")
podcasts.site = site
podcasts.parent = broadcasts_index
podcasts.title = "Podcasts"
podcasts.slug = "podcasts"
podcasts.published = true
podcasts.locked = true
podcasts.page_order_position = :last if podcasts.new_record?
podcasts.save!

# People page
# ------------------------------------------------------------------------------
people = Heracles::Sites::WheelerCentre::People.find_or_initialize_by(url: "people")
people.site = site
people.title = "People"
people.slug = "people"
people.published = true
people.locked = true
people.page_order_position = :last if people.new_record?
people.save!

# People -> People collection
people_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "people/all-people")
people_collection.parent = people
people_collection.site = site
people_collection.title = "All People"
people_collection.slug = "all-people"
people_collection.fields[:contained_page_type].value = :person
people_collection.fields[:sort_attribute].value = "created_at"
people_collection.fields[:sort_direction].value = "DESC"
people_collection.published = false
people_collection.locked = true
people_collection.page_order_position = :last if people_collection.new_record?
people_collection.save!

# Topics
# ------------------------------------------------------------------------------
topics = Heracles::Sites::WheelerCentre::Topics.find_or_initialize_by(url: "topics")
topics.site = site
topics.title = "Topics"
topics.slug = "topics"
topics.published = true
topics.locked = false
topics.page_order_position = :last if topics.new_record?
topics.save!

topic_names = [
  {
    name: "Books, reading & writing",
    children: [
      {
        name: "Fiction",
        children: [
          {name: "Classics"},
          {name: "Crime & pulp"},
          {name: "Erotica"},
          {name: "Fantasy"},
          {name: "Romance"},
          {name: "Science fiction"},
          {name: "Young adult"},
        ]
      },
      {
        name: "Non-fiction",
        children: [
          {name: "Biography & memoir"},
          {name: "History"},
          {name: "Travel"},
          {name: "Crime"},
        ]
      },
      {name: "Children’s books"},
      {name: "Poetry"},
      {name: "Graphic novels & comics"},
      {name: "Criticism"},
      {name: "Australian stories"},
      {name: "Editing, publishing & book design"},
      {name: "Journals & magazines"},
      {name: "New & emerging writers"},
      {name: "Bookshops"},
      {name: "Awards & prizes"},
      {name: "Words & language"},
      {name: "Funding"},
      {name: "Creativity"},
    ]
  },
  {
    name: "Visual art & design",
    children: [
      {
        name: "Art",
        children: [
          {name: "Visual art"},
          {name: "Sculpture"},
          {name: "Painting"},
          {name: "Illustration"},
          {name: "Media art"},
          {name: "Art history"},
        ]
      },
      {name: "Industrial design"},
      {name: "Architecture"},
      {name: "Urban design"},
      {name: "Fashion"},
      {name: "Jewellery"},
      {name: "Graphic design"},
      {name: "Funding"},
    ]
  },
  {
    name: "Performing Arts & Pop Culture",
    children: [
      {name: "Music"},
      {name: "Film"},
      {name: "Theatre"},
      {name: "Dance"},
      {name: "TV"},
      {name: "Radio"},
      {name: "Sport"},
      {name: "Games"},
      {name: "Creativity"},
      {name: "Media"},
    ]
  },
  {
    name: "History, politics & current affairs",
    children: [
      {name: "Australian politics"},
      {name: "History"},
      {name: "Defence, military & war"},
      {name: "Activism"},
      {name: "International relations & diplomacy"},
      {name: "Government"},
      {name: "Sexual & gender politics"},
      {name: "Speech & oration"},
    ]
  },
  {
    name: "Free speech, human rights & social issues",
    children: [
      {name: "Freedom of speech & censorship"},
      {name: "Social justice"},
      {name: "Human rights"},
      {name: "Privacy"},
      {name: "Activism"},
      {name: "Community"},
      {name: "Gambling"},
    ]
  },
  {
    name: "Race, religion & identity",
    children: [
      {name: "Race & multiculturalism"},
      {name: "Identity"},
      {name: "Faith, religion & spirituality"},
      {name: "Diversity"},
      {name: "Young people"},
      {name: "Indigenous"},
      {name: "Migration"},
      {name: "Australia"},
      {name: "Africa & Middle East"},
      {name: "Asia & Pacific"},
      {name: "Europe"},
      {name: "The Americas"},
    ]
  },
  {
    name: "Sex & gender",
    children: [
      {name: "Sex & relationships"},
      {name: "Gender"},
      {name: "Sexuality"},
      {name: "Sexism & feminism"},
      {name: "Erotica"},
    ]
  },
  {
    name: "Internet, journalism, media & publishing",
    children: [
      {name: "Digital culture"},
      {name: "Publishing & editing"},
      {name: "Media"},
      {name: "Privacy & security"},
      {name: "Leaking & whistleblowing"},
    ]
  },
  {
    name: "Economics, business & marketing",
    children: [
      {name: "Economy & development"},
      {name: "Work"},
      {name: "Marketing & publicity"},
      {name: "Advertising"},
      {name: "Business & finance"},
      {name: "Funding & philanthropy"},
    ]
  },
  {
    name: "Education, literacy & numeracy",
    children: [
      {name: "Education"},
      {name: "Literacy"},
      {name: "Mathematics"},
    ]
  },
  {
    name: "Energy, environment & climate",
    children: [
      {name: "Environment"},
      {name: "Climate change & weather"},
      {name: "Energy & resources"},
      {name: "Food"},
      {name: "Animals & nature"},
      {name: "Cities"},
      {name: "Country & rural"},
    ]
  },
  {
    name: "Health, medicine & psychology",
    children: [
      {name: "Life & death"},
      {name: "Health & medicine"},
      {name: "Disability"},
      {name: "Deaf"},
      {name: "Psychology & mental health"},
      {name: "Food & nutrition"},
      {name: "Young & old"},
      {name: "Drugs"},
      {name: "Sport"},
    ]
  },
  {
    name: "Science & technology",
    children: [
      {name: "Technology"},
      {name: "Research"},
      {name: "Biology"},
      {name: "Chemistry"},
      {name: "Physics"},
      {name: "Space"},
    ]
  },
  {
    name: "Law, ethics & philosophy",
    children: [
      {name: "Law"},
      {name: "Crime"},
      {name: "Ethics & morals"},
      {name: "Philosophy"},
      {name: "Privacy & security"},
    ]
  },
  {
    name: "Comedy & humour",
    children: [
      {name: "Comedy"},
      {name: "Humour"},
      {name: "Satire"},
    ]
  }
]

def build_topic_page(topic, parent, site)
  slug = slugify(topic[:name])
  # puts "*************"
  # puts topic[:name]
  # puts slug
  page = Heracles::Sites::WheelerCentre::Topic.find_or_initialize_by(url: "#{parent.absolute_url}/#{slug}")
  page.site = site
  page.slug = slug
  page.parent = parent
  page.title = topic[:name]
  page.published = true
  page.page_order_position = :last if page.new_record? if page.new_record?
  page.save!
  if topic[:children].present?
    topic[:children].each do |child|
      build_topic_page(child, page, site)
    end
  end
end

topic_names.each do |topic|
  build_topic_page(topic, topics, site)
end


# About us
# ------------------------------------------------------------------------------
about_us = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us")
about_us.site = site
about_us.title = "About us"
about_us.slug = "about-us"
about_us.published = true
about_us.locked = false
about_us.page_order_position = :last if about_us.new_record? if about_us.new_record?
about_us.save!

# About us -> Who we are
who = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "who-we-are")
who.site = site
who.parent = about_us
who.title = "Who we are"
who.slug = "who-we-are"
who.published = true
who.locked = false
who.page_order_position = :last if who.new_record?
who.save!

# About us -> Who funds us
funds = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "who-funds-us")
funds.site = site
funds.parent = about_us
funds.title = "Who funds us"
funds.slug = "who-funds-us"
funds.published = true
funds.locked = false
funds.page_order_position = :last if funds.new_record?
funds.save!

# About us -> Who funds us -> Support us
support_us = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "support-us")
support_us.site = site
support_us.parent = funds
support_us.title = "Support us"
support_us.slug = "support-us"
support_us.published = true
support_us.locked = false
support_us.page_order_position = :last if support_us.new_record?
support_us.save!

# About us -> Who funds us -> Sponsors
sponsors = Heracles::Sites::WheelerCentre::Sponsors.find_or_initialize_by(url: "sponsors")
sponsors.site = site
sponsors.parent = funds
sponsors.title = "Sponsors"
sponsors.slug = "sponsors"
sponsors.published = true
sponsors.locked = true
sponsors.page_order_position = :last if sponsors.new_record?
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
sponsors_collection.page_order_position = :last if sponsors_collection.new_record?
sponsors_collection.save!

# About us -> Residents
residents = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "resident-organisations")
residents.site = site
residents.parent = about_us
residents.title = "Resident organisations"
residents.slug = "resident-organisations"
residents.published = true
residents.locked = false
residents.page_order_position = :last if residents.new_record?
residents.save!

# About us -> Ticketing
ticketing = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "ticketing")
ticketing.site = site
ticketing.parent = about_us
ticketing.title = "Ticketing"
ticketing.slug = "ticketing"
ticketing.published = true
ticketing.locked = false
ticketing.page_order_position = :last if ticketing.new_record?
ticketing.save!

# About us -> FAQs
faqs = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "faqs")
faqs.site = site
faqs.parent = about_us
faqs.title = "FAQs"
faqs.slug = "faqs"
faqs.published = true
faqs.locked = false
faqs.page_order_position = :last if faqs.new_record?
faqs.save!

# About us -> Privacy policy
privacy = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "privacy")
privacy.site = site
privacy.parent = about_us
privacy.title = "Privacy policy"
privacy.slug = "privacy"
privacy.published = true
privacy.locked = false
privacy.page_order_position = :last if privacy.new_record?
privacy.save!

# About us -> Community guidelines
community_guidelines = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "community-guidelines")
community_guidelines.site = site
community_guidelines.parent = about_us
community_guidelines.title = "Community guidelines"
community_guidelines.slug = "community-guidelines"
community_guidelines.published = true
community_guidelines.locked = false
community_guidelines.page_order_position = :last if community_guidelines.new_record?
community_guidelines.save!
