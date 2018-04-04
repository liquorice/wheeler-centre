def generate_title
  title = FFaker::Lorem.words(3).join(" ")
  title[0].upcase + title[1..-1]
end

def generate_color
  # (1..6).map { (("a".."f").to_a + (0..9).to_a).sample.to_s }.join
  FFaker::Color.hex_code
end

def slugify(name)
  name.downcase.gsub(/\&/, "and").gsub(/[^a-zA-Z0-9]/, ' ').gsub(/\s+/, '-')
end

namespace :temporary do
  desc "Set up /notes and /news split"
  task setup_new_notes: :environment do
    site = Heracles::Site.first

    # Notes
    longform_blog = Heracles::Sites::WheelerCentre::LongformBlog.find_or_initialize_by(url: "new-notes")
    longform_blog.site = site
    longform_blog.title = "Notes"
    longform_blog.slug = "new-notes"
    longform_blog.published = true
    longform_blog.locked = true
    longform_blog.page_order_position = :last if longform_blog.new_record?
    longform_blog.save!

    # Notes -> 'All notes' collection
    notes_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "new-notes/all-notes")
    notes_collection.parent = longform_blog
    notes_collection.site = site
    notes_collection.title = "All Notes"
    notes_collection.slug = "all-notes"
    notes_collection.fields[:contained_page_type].value = :longform_blog_post
    notes_collection.fields[:sort_attribute].value = "created_at"
    notes_collection.fields[:sort_direction].value = "DESC"
    notes_collection.published = false
    notes_collection.locked = true
    notes_collection.page_order_position = :last if notes_collection.new_record?
    notes_collection.save!

    # Notes -> 'All editions' collection
    title = generate_title
    slug = slugify(title)
    editions_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "new-notes/all-editions")
    editions_collection.parent = longform_blog
    editions_collection.site = site
    editions_collection.title = "All Editions"
    editions_collection.slug = "all-editions"
    editions_collection.fields[:contained_page_type].value = :longform_blog_edition
    editions_collection.fields[:sort_attribute].value = "created_at"
    editions_collection.fields[:sort_direction].value = "DESC"
    editions_collection.published = false
    editions_collection.locked = true
    editions_collection.page_order_position = :last if editions_collection.new_record?
    editions_collection.save!

    # Notes archive
    longform_blog_archive = Heracles::Sites::WheelerCentre::LongformBlogArchive.find_or_initialize_by(url: "new-notes/archive")
    longform_blog_archive.parent = longform_blog
    longform_blog_archive.site = site
    longform_blog_archive.title = "Archive"
    longform_blog_archive.slug = "archive"
    longform_blog_archive.published = true
    longform_blog_archive.locked = true
    longform_blog_archive.page_order_position = :last if longform_blog_archive.new_record?
    longform_blog_archive.save!

    # Create some editions
    (1..4).each do
      title = generate_title
      slug = slugify(title)
      edition = Heracles::Sites::WheelerCentre::LongformBlogEdition.find_or_initialize_by(url: "new-notes/#{slug}")
      edition.collection = editions_collection
      edition.parent = longform_blog
      edition.site = site
      edition.title = title
      edition.slug = slug
      edition.published = true
      edition.locked = true
      edition.page_order_position = :last if edition.new_record?
      edition.fields[:highlight_colour].value = generate_color
      a_blog_post = Heracles::Site.first.pages.of_type("blog_post").reorder(created_at: :desc).limit(20).map { |p| p if p.fields[:hero_image].data_present? }.compact.sample
      edition.fields[:hero_image].asset_ids = a_blog_post.fields[:hero_image].assets.map(&:id)
      edition.save!
    end

    # migrate some posts across
    # grab the ones tagged with 'notes'
    notes = Heracles::Site.first.pages.of_type("blog_post").tagged_with("notes")
    notes.each_with_index do |note, i|
      post = Heracles::Sites::WheelerCentre::LongformBlogPost.find_or_initialize_by(url: "new-notes/#{slug}")
      post.collection = notes_collection
      post.parent = longform_blog
      post.site = site
      post.published = true
      post.locked = false
      post.page_order_position = :last if post.new_record?
      post.title = note.title
      post.slug = note.slug
      post.fields.data = note.fields.data
      post.fields[:edition].page_ids = [Heracles::Sites::WheelerCentre::LongformBlogEdition.all.sample.id]
      post.save!
    end

    # Change notes page to "news"
    blog_page = Heracles::Sites::WheelerCentre::Blog.first
    blog_page.title = "News"
    blog_page.save!

    blog_archive = Heracles::Sites::WheelerCentre::BlogArchive.first
    blog_archive.fields[:nav_title].value = "News archive"
    blog_archive.save!
  end
end
