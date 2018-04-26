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
    longform_blog.fields[:nav_title].value = "Editions"
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
    longform_blog_archive.title = "Browse all notes"
    longform_blog_archive.slug = "browse-all-notes"
    longform_blog_archive.published = true
    longform_blog_archive.locked = true
    longform_blog_archive.page_order_position = :last if longform_blog_archive.new_record?
    longform_blog_archive.save!

    # migrate some posts across
    # grab the ones tagged with 'notes'
    notes = Heracles::Site.first.pages.of_type("blog_post").tagged_with("notes")
    created_notes = notes.each_with_index.map do |note, i|
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
      post.save!
      post
    end

    # Create some editions
    editions = (1..4).map do |index|
      title = index == 1 ? "Hushhhy" : generate_title
      slug = slugify(title)
      edition = Heracles::Sites::WheelerCentre::LongformBlogEdition.find_or_initialize_by(url: "new-notes/#{slug}")
      edition.collection = editions_collection
      edition.parent = longform_blog
      edition.site = site
      edition.title = title
      edition.fields[:subheading].value = "Featured Notes"
      edition.slug = slug
      edition.published = true
      edition.locked = true
      edition.page_order_position = :last if edition.new_record?
      if index == 1
        edition.fields[:intro].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>"
        edition.fields[:end].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>"
      end
      edition.fields[:summary].value = "<div contenteditable=\"false\" insertable=\"image\" value='{\"id\":\"3ec62d9b-28c1-45a3-a0c4-97d12fcecd29\",\"file_name\":\"2018 04 Notes - Hush edition - Cover art final by Sophie Beer (square crop).jpg\",\"content_type\":\"image/jpeg\",\"raw_width\":3024,\"raw_height\":3024,\"raw_orientation\":1,\"corrected_width\":3024,\"corrected_height\":3024,\"corrected_orientation\":\"square\",\"original_path\":\"786/c51/5b0/786c515b0b13070b939687335ac2895e2b06cd38c7eb19e3b52daf8944d6/2018 04 Notes - Hush edition - Cover art final by Sophie Beer (square crop).jpg\",\"original_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/786/c51/5b0/786c515b0b13070b939687335ac2895e2b06cd38c7eb19e3b52daf8944d6/2018 04 Notes - Hush edition - Cover art final by Sophie Beer (square crop).jpg\",\"size\":5154173,\"title\":\"\",\"description\":\"\",\"attribution\":\"Illustration: Sophie Beer\",\"tag_list\":[],\"processed\":true,\"created_at\":\"2018-04-06T12:15:59.747+10:00\",\"thumbnail_url\":\"https://wheeler-centre-heracles.s3-ap-southeast-2.amazonaws.com/processed/77/64b920394011e8995eb906b441aeb6/7814f650394011e888f77dffce27b7ab_heracles_admin_thumbnail.jpg\",\"preview_url\":\"https://wheeler-centre-heracles.s3-ap-southeast-2.amazonaws.com/processed/77/64b920394011e8995eb906b441aeb6/7812ac60394011e8ab6449b6848afdd6_heracles_admin_preview.jpg\",\"asset_id\":\"3ec62d9b-28c1-45a3-a0c4-97d12fcecd29\",\"display\":\"Center-aligned\",\"width\":\"50%\"}'></div>\n<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
      # edition.fields[:hero_image].asset_ids = [Heracles::Asset.find("834bd7de-b68f-4c7d-bae8-646cf5d33731").id]
      edition.fields[:notes].page_ids = (0..8).to_a.map do
        sample_note = created_notes.sample
        created_notes -= [sample_note]
        sample_note.id
      end
      edition.save!
      edition
    end

    longform_blog.fields[:featured_editions].page_ids = editions.map(&:id)
    longform_blog.save!

    # Heracles::Site.first.pages.of_type(:longform_blog_edition).each do |edition|
    #   edition.fields[:summary].value = edition.fields[:hero_content].value
    #   edition.save!
    # end
  end
end
