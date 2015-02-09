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
      "zoom" => true,
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
      "zoom" => true,
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
    "itunes_resized" => {
      "robot" => "/image/resize",
      "use" => ":original",
      "width" => 1400,
      "height" => 1400,
      "quality" => 75,
      "resize_strategy" => "crop",
      "gravity" => "center",
      "zoom" => true,
      "strip" => true
    },
    "itunes" => {
      "robot" => "/image/optimize",
      "use" => ["itunes_resized"]
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
      "ffmpeg_stack" => "v2.2.3",
      "preset" => "ipad-high"
    },
    "video_iphone_high" => {
      "robot" => "/video/encode",
      "use" => ":original",
      "ffmpeg_stack" => "v2.2.3",
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
        "itunes",
        "audio_mp3",
        "audio_ogg",
        "video_ipad_high",
        "video_iphone_high"
      ]
    }
  }
}

# This template is needs to be set _in_ Transloadit for some reason
# additional_template = {
#   "store_youtube" => {
#     "robot" => "/youtube/store",
#     "use" => [":original"],
#     "username" => "",
#     "password" => "",
#     "title" => "${file.name}",
#     "description" => "${file.name} description",
#     "category" => "People & Blogs",
#     "keywords" => "Ideas, Melbourne, Australia, Conversation, The Wheeler Centre, Victoria, Writing",
#     "visibility" => "private"
#   }
# }
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
event_series_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/series/all-event-series")
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
presenters = Heracles::Sites::WheelerCentre::Presenters.find_or_initialize_by(url: "events/presenters")
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
venues_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "events/venues/all-event-venues")
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

# Events -> Past events
past_events = Heracles::Sites::WheelerCentre::EventsArchive.find_or_initialize_by(url: "events/past-events")
past_events.site = site
past_events.parent = events_index
past_events.title = "Past events"
past_events.slug = "past-events"
past_events.published = true
past_events.locked = true
past_events.page_order_position = :last if past_events.new_record?
past_events.save!


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
broadcasts_index = Heracles::Sites::WheelerCentre::Broadcasts.find_or_initialize_by(url: "broadcasts")
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
podcasts = Heracles::Sites::WheelerCentre::Podcasts.find_or_initialize_by(url: "broadcasts/podcasts")
podcasts.site = site
podcasts.parent = broadcasts_index
podcasts.title = "Podcasts"
podcasts.slug = "podcasts"
podcasts.published = true
podcasts.locked = true
podcasts.page_order_position = :last if podcasts.new_record?
podcasts.save!

# Create the default "Wheeler Centre" podcast structure
params = {
  parent: podcasts,
  page_order_position: :last,
  published: true,
  slug: "the-wheeler-centre",
  title: "The Wheeler Centre",
  created_at: Time.now
}
wheeler_podcast = Heracles::Page.find_by_url("broadcasts/podcasts/#{params[:slug]}")
unless wheeler_podcast
  result = Heracles::CreatePage.call(site: site, page_type: "podcast_series", page_params: params)
  wheeler_podcast = result.page
end

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
  page = Heracles::Sites::WheelerCentre::Topic.find_or_initialize_by(url: "#{parent.absolute_url.gsub(/^\//, "")}/#{slug}")
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

# Delete all topic pages
# Heracles::Page.of_type("topic").delete_all

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
who = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/who-we-are")
who.site = site
who.parent = about_us
who.title = "Who we are"
who.slug = "who-we-are"
who.published = true
who.locked = false
who.page_order_position = :last if who.new_record?
who.save!

# About us -> Who funds us
funds = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/who-funds-us")
funds.site = site
funds.parent = about_us
funds.title = "Who funds us"
funds.slug = "who-funds-us"
funds.published = true
funds.locked = false
funds.page_order_position = :last if funds.new_record?
funds.save!

# About us -> Who funds us -> Support us
support_us = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/who-funds-us/support-us")
support_us.site = site
support_us.parent = funds
support_us.title = "Support us"
support_us.slug = "support-us"
support_us.published = true
support_us.locked = false
support_us.page_order_position = :last if support_us.new_record?
support_us.save!

# About us -> Who funds us -> Sponsors
sponsors = Heracles::Sites::WheelerCentre::Sponsors.find_or_initialize_by(url: "about-us/who-funds-us/sponsors")
sponsors.site = site
sponsors.parent = funds
sponsors.title = "Sponsors"
sponsors.slug = "sponsors"
sponsors.published = true
sponsors.locked = true
sponsors.page_order_position = :last if sponsors.new_record?
sponsors.save!

# About us -> Who funds us -> Sponsors -> Sponsors collection
sponsors_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "about-us/who-funds-us/sponsors/all-sponsors")
sponsors_collection.parent = sponsors
sponsors_collection.site = site
sponsors_collection.title = "All sponsors"
sponsors_collection.slug = "all-sponsors"
sponsors_collection.fields[:contained_page_type].value = "sponsor"
sponsors_collection.fields[:sort_attribute].value = "created_at"
sponsors_collection.fields[:sort_direction].value = "DESC"
sponsors_collection.published = false
sponsors_collection.locked = true
sponsors_collection.page_order_position = :last if sponsors_collection.new_record?
sponsors_collection.save!

# About us -> Residents
residents = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/resident-organisations")
residents.site = site
residents.parent = about_us
residents.title = "Resident organisations"
residents.slug = "resident-organisations"
residents.published = true
residents.locked = false
residents.page_order_position = :last if residents.new_record?
residents.save!

# About us -> Ticketing
ticketing = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/ticketing")
ticketing.site = site
ticketing.parent = about_us
ticketing.title = "Ticketing"
ticketing.slug = "ticketing"
ticketing.published = true
ticketing.locked = false
ticketing.page_order_position = :last if ticketing.new_record?
ticketing.save!

# About us -> FAQs
faqs = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/faqs")
faqs.site = site
faqs.parent = about_us
faqs.title = "FAQs"
faqs.slug = "faqs"
faqs.published = true
faqs.locked = false
faqs.page_order_position = :last if faqs.new_record?
faqs.save!

# About us -> Privacy policy
privacy = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/privacy")
privacy.site = site
privacy.parent = about_us
privacy.title = "Privacy policy"
privacy.slug = "privacy"
privacy.published = true
privacy.locked = false
privacy.page_order_position = :last if privacy.new_record?
privacy.save!

# About us -> Community guidelines
community_guidelines = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "about-us/community-guidelines")
community_guidelines.site = site
community_guidelines.parent = about_us
community_guidelines.title = "Community guidelines"
community_guidelines.slug = "community-guidelines"
community_guidelines.published = true
community_guidelines.locked = false
community_guidelines.page_order_position = :last if community_guidelines.new_record?
community_guidelines.save!

# Settings
# ------------------------------------------------------------------------------

# Hidden settings page
settings = Heracles::Sites::WheelerCentre::Settings.find_or_initialize_by(url: "settings")
settings.site = site
settings.title = "Settings"
settings.slug = "settings"
settings.published = true
settings.hidden = true
settings.locked = true
settings.page_order_position = :last if settings.new_record?
settings.save!

itunes_categories = {
  name: "Arts",
  children: [
    { name: "Design" },
    { name: "Fashion & Beauty" },
    { name: "Food" },
    { name: "Literature" },
    { name: "Performing Arts" },
    { name: "Spoken Word" },
    { name: "Visual Arts" },
  ]
},
{
  name: "Business",
  children: [
    { name: "Business News" },
    { name: "Careers" },
    { name: "Investing" },
    { name: "Management & Marketing" },
    { name: "Shopping" },
  ]
},
{
  name: "Comedy"
},
{
  name: "Education",
  children: [
    { name: "Educational Technology" },
    { name: "Higher Education" },
    { name: "K-12" },
    { name: "Language Courses" },
    { name: "Training" },
  ]
},
{
  name: "Games & Hobbies",
  children: [
    { name: "Automotive" },
    { name: "Aviation" },
    { name: "Hobbies" },
    { name: "Other Games" },
    { name: "Video Games" },
  ]
},
{
  name: "Government & Organizations",
  children: [
    { name: "Local" },
    { name: "National" },
    { name: "Non-Profit" },
    { name: "Regional" },
  ]
},
{
  name: "Health",
  children: [
    { name: "Alternative Health" },
    { name: "Fitness & Nutrition" },
    { name: "Self-Help" },
    { name: "Sexuality" },
    { name: "Kids & Family" },
  ]
},
{
  name: "Music",
  children: [
    { name: "Alternative" },
    { name: "Blues" },
    { name: "Country" },
    { name: "Easy Listening" },
    {
      name: "Electronic",
      children: [
        { name: "Acid House" },
        { name: "Ambient" },
        { name: "Big Beat" },
        { name: "Breakbeat" },
        { name: "Disco" },
        { name: "Downtempo" },
        { name: "Drum 'n' Bass" },
        { name: "Garage" },
        { name: "Hard House" },
        { name: "House" },
        { name: "IDM" },
        { name: "Jungle" },
        { name: "Progressive" },
        { name: "Techno" },
        { name: "Trance" },
        { name: "Tribal" },
        { name: "Trip Hop" },
      ]
    },
    { name: "Folk" },
    { name: "Freeform" },
    { name: "Hip-Hop & Rap" },
    { name: "Inspirational" },
    { name: "Jazz" },
    { name: "Latin" },
    { name: "Metal" },
    { name: "New Age" },
    { name: "Oldies" },
    { name: "Pop" },
    { name: "R&B & Urban" },
    { name: "Reggae" },
    { name: "Rock" },
    { name: "Seasonal & Holiday" },
    { name: "Soundtracks" },
    { name: "World" },
  ]
},
{
  name: "News & Politics",
  children: [
    { name: "Conservative (Right)" },
    { name: "Liberal (Left)" },
  ]
},
{
  name: "Religion & Spirituality",
  children: [
    { name: "Buddhism" },
    { name: "Christianity" },
    { name: "Hinduism" },
    { name: "Islam" },
    { name: "Judaism" },
    { name: "Other" },
    { name: "Spirituality" },
  ]
},
{
  name: "Science & Medicine",
  children: [
    { name: "Medicine" },
    { name: "Natural Sciences" },
    { name: "Social Sciences" },
  ]
},
{
  name: "Society & Culture",
  children: [
    { name: "Gay & Lesbian" },
    { name: "History" },
    { name: "Personal Journals" },
    { name: "Philosophy" },
    { name: "Places & Travel" },
  ]
},
{
  name: "Sports & Recreation",
  children: [
    { name: "Amateur" },
    { name: "College & High School" },
    { name: "Outdoor" },
    { name: "Professional" },
  ]
},
{
  name: "TV & Film",
  children: [
  ]
},
{
  name: "Technology",
  children: [
    { name: "Gadgets" },
    { name: "IT News" },
    { name: "Podcasting" },
    { name: "Software How-To" },
  ]
}

def build_itunes_category_page(category, parent, site)
  slug = slugify(category[:name])
  # puts "*************"
  # puts category[:name]
  # puts slug
  page = Heracles::Sites::WheelerCentre::ItunesCategory.find_or_initialize_by(url: "#{parent.absolute_url.gsub(/^\//, "")}/#{slug}")
  page.site = site
  page.slug = slug
  page.parent = parent
  page.title = category[:name]
  page.published = true
  page.page_order_position = :last if page.new_record? if page.new_record?
  page.save!
  if category[:children].present?
    category[:children].each do |child|
      build_itunes_category_page(child, page, site)
    end
  end
end

itunes_category_index = Heracles::Sites::WheelerCentre::Placeholder.find_or_initialize_by(url: "settings/itunes-categories")
itunes_category_index.site = site
itunes_category_index.parent = settings
itunes_category_index.title = "iTunes categories"
itunes_category_index.slug = "itunes-categories"
itunes_category_index.published = true
itunes_category_index.hidden = true
itunes_category_index.page_order_position = :last if itunes_category_index.new_record?
itunes_category_index.save!

itunes_categories.each do |category|
  build_itunes_category_page(category, itunes_category_index, site)
end

# Homepage banners

home_banners_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "settings/home-banners")
home_banners_collection.parent = settings
home_banners_collection.site = site
home_banners_collection.title = "Home page banners"
home_banners_collection.slug = "home-banners"
home_banners_collection.fields[:contained_page_type].value = :home_banner
home_banners_collection.fields[:sort_attribute].value = "created_at"
home_banners_collection.fields[:sort_direction].value = "DESC"
home_banners_collection.published = false
home_banners_collection.locked = true
home_banners_collection.page_order_position = :last if home_banners_collection.new_record?
home_banners_collection.save!

home_quotes_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "settings/home-quotes")
home_quotes_collection.parent = settings
home_quotes_collection.site = site
home_quotes_collection.title = "Home page quotes"
home_quotes_collection.slug = "home-quotes"
home_quotes_collection.fields[:contained_page_type].value = :home_quote
home_quotes_collection.fields[:sort_attribute].value = "created_at"
home_quotes_collection.fields[:sort_direction].value = "DESC"
home_quotes_collection.published = false
home_quotes_collection.locked = true
home_quotes_collection.page_order_position = :last if home_quotes_collection.new_record?
home_quotes_collection.save!
