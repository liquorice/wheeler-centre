# Populate the database with a small set of realistic sample data so that as a
# developer/designer, you can use the application without having to create a
# bunch of stuff or pull down production data.
#
# After running db:sample_data, a developer/designer should be able to fire up
# the app, sign in, browse data and see examples of practically anything
# (interesting) that can happen in the system.
#
# It's a good idea to build this up along with the features; when you build a
# feature, make sure you can easily demo it after running db:sample_data.
#
# Data that is required by the application across all environments (i.e.
# reference data) should _not_ be included here. That belongs in seeds.rb
# instead.

# Site
site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

# Sample events
events = Heracles::Page.where(url: "events").first!
events_collection = Heracles::Page.where(url: "events/all-events").first!

events_collection.pages.destroy_all

5.times do |num|
  _event = Heracles::Page.new_for_site_and_page_type(site, "event").tap do |page|
    page.parent = events
    page.collection = events_collection
    page.title = Faker::HipsterIpsum.words(5).join(" ").titleize
    page.slug = page.title.downcase.gsub(/\s+/, "-")
    page.published = true
    page.fields[:start_date].value = num.days.from_now
    page.fields[:end_date].value = (num+1).days.from_now
    page.fields[:body].value = Faker::HipsterIpsum.sentences(12).in_groups_of(3).map { |group| group.join(" ") }.map { |sentences| "<p>#{sentences}</p>" }.join("")
    page.page_order_position = :last
    page.save!
  end
end

# Sample blog posts
blog = Heracles::Page.where(url: "blog").first!
blog_collection = Heracles::Page.where(url: "blog/all-posts").first!

blog_collection.pages.destroy_all

5.times do |num|
  _blog_post = Heracles::Page.new_for_site_and_page_type(site, "blog_post").tap do |page|
    page.parent = blog
    page.collection = blog_collection
    page.title = Faker::HipsterIpsum.words(5).join(" ").titleize
    page.slug = page.title.downcase.gsub(/\s+/, "-")
    page.published = true
    page.fields[:body].value = Faker::HipsterIpsum.sentences(6).map { |s| "<p>#{s}</p>" }.join("")
    page.page_order_position = :last
    page.save!
  end
end

# Sample people
people = Heracles::Page.where(url: "people").first!
people_collection = Heracles::Page.where(url: "people/all-people").first!

people_collection.pages.destroy_all

5.times do |num|
  _person = Heracles::Page.new_for_site_and_page_type(site, "person").tap do |page|
    page.parent = people
    page.collection = people_collection
    page.title = Faker::HipsterIpsum.words(2).join(" ").titleize
    page.slug = page.title.downcase.gsub(/\s+/, "-")
    page.published = true
    page.fields[:biography].value = Faker::HipsterIpsum.sentences(6).map { |s| "<p>#{s}</p>" }.join("")
    page.page_order_position = :last
    page.save!
  end
end



