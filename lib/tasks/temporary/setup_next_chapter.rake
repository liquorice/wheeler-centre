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
  desc "Set up next chapter, yo"
  task setup_next_chapter: :environment do
    site = Heracles::Site.first

    home_page = Heracles::Sites::WheelerCentre::NextChapterHomePage.find_or_initialize_by(url: "the-next-chapter")
    home_page.site = site
    home_page.title = "The Next Chapter"
    home_page.slug = "the-next-chapter"
    home_page.fields[:body].value = "<p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo <span>inventore veritatis et quasi</span> architecto beatae vitae dicta sunt explicabo.</p>\n<div contenteditable=\"false\" insertable=\"image\" value='{\"id\":\"0b7a88c9-5c8b-47ad-8ba7-59aa4aa79870\",\"file_name\":\"2017 12 Show of the Year - 1600x1200 - event tile.jpg\",\"content_type\":\"image/jpeg\",\"raw_width\":3333,\"raw_height\":2500,\"raw_orientation\":null,\"corrected_width\":3333,\"corrected_height\":2500,\"corrected_orientation\":\"landscape\",\"original_path\":\"4d2/294/715/4d2294715c9d79563b97cb525563f2bdc22fcfece3611d82c65a4cd5770d/2017 12 Show of the Year - 1600x1200 - event tile.jpg\",\"original_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/4d2/294/715/4d2294715c9d79563b97cb525563f2bdc22fcfece3611d82c65a4cd5770d/2017 12 Show of the Year - 1600x1200 - event tile.jpg\",\"size\":503654,\"title\":null,\"description\":null,\"attribution\":null,\"tag_list\":[],\"processed\":true,\"created_at\":\"2017-10-05T15:58:46.123+11:00\",\"thumbnail_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/processed/e3/9e8540a98911e789446192df3e5dcb/e4a96590a98911e7a130271026fac4dc_heracles_admin_thumbnail.jpg\",\"preview_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/processed/e3/9e8540a98911e789446192df3e5dcb/e4add260a98911e7917f49095c54042e_heracles_admin_preview.jpg\",\"asset_id\":\"0b7a88c9-5c8b-47ad-8ba7-59aa4aa79870\",\"display\":\"Right-aligned\",\"caption\":\"This is a image caption\"}'></div>\n<p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>\n<h1>Heading one</h1>\n<p>Inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium eaque ipsa quae ab.</p>\n<p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>\n<h2>Heading two</h2>\n<p>Inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium eaque ipsa quae ab.</p>"
    home_page.published = true
    home_page.locked = true
    home_page.page_order_position = :last if home_page.new_record?
    home_page.save!

    # What is the Next Chapter?
    what_is_the_next_chapter_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/what-is-the-next-chapter")
    what_is_the_next_chapter_page.parent = home_page
    what_is_the_next_chapter_page.site = site
    what_is_the_next_chapter_page.title = "What is the Next Chapter?"
    what_is_the_next_chapter_page.slug = "what-is-the-next-chapter"
    what_is_the_next_chapter_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    what_is_the_next_chapter_page.published = true
    what_is_the_next_chapter_page.locked = false
    what_is_the_next_chapter_page.page_order_position = :last if what_is_the_next_chapter_page.new_record?
    what_is_the_next_chapter_page.save!

    # Meet the writers
    meet_the_writers_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/meet-the-writers")
    meet_the_writers_page.parent = home_page
    meet_the_writers_page.site = site
    meet_the_writers_page.title = "Meet the writers"
    meet_the_writers_page.slug = "meet-the-writers"
    meet_the_writers_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    meet_the_writers_page.published = true
    meet_the_writers_page.locked = false
    meet_the_writers_page.page_order_position = :last if meet_the_writers_page.new_record?
    meet_the_writers_page.save!

    # Meet the writers 2018
    meet_the_writers_2018_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/meet-the-writers/2018")
    meet_the_writers_2018_page.parent = meet_the_writers_page
    meet_the_writers_2018_page.site = site
    meet_the_writers_2018_page.title = "2018"
    meet_the_writers_2018_page.slug = "2018"
    meet_the_writers_2018_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    meet_the_writers_2018_page.published = true
    meet_the_writers_2018_page.locked = false
    meet_the_writers_2018_page.page_order_position = :last if meet_the_writers_2018_page.new_record?
    meet_the_writers_2018_page.save!

    # Meet the readers
    meet_the_readers_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/meet-the-readers")
    meet_the_readers_page.parent = home_page
    meet_the_readers_page.site = site
    meet_the_readers_page.title = "Meet the readers"
    meet_the_readers_page.slug = "meet-the-readers"
    meet_the_readers_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    meet_the_readers_page.published = true
    meet_the_readers_page.locked = false
    meet_the_readers_page.page_order_position = :last if meet_the_readers_page.new_record?
    meet_the_readers_page.save!

    # Meet the readers 2018
    meet_the_readers_2018_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/meet-the-readers/2018")
    meet_the_readers_2018_page.parent = meet_the_readers_page
    meet_the_readers_2018_page.site = site
    meet_the_readers_2018_page.title = "2018"
    meet_the_readers_2018_page.slug = "2018"
    meet_the_readers_2018_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    meet_the_readers_2018_page.published = true
    meet_the_readers_2018_page.locked = false
    meet_the_readers_2018_page.page_order_position = :last if meet_the_readers_2018_page.new_record?
    meet_the_readers_2018_page.save!

    # News...
    news_page = Heracles::Sites::WheelerCentre::NextChapterBlog.find_or_initialize_by(url: "the-next-chapter/news")
    news_page.parent = home_page
    news_page.site = site
    news_page.title = "News"
    news_page.slug = "news"
    news_page.published = true
    news_page.locked = false
    news_page.page_order_position = :last if news_page.new_record?
    news_page.save!

    # News -> 'All news' collection
    news_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: "the-next-chapter/news/all-news")
    news_collection.parent = news_page
    news_collection.site = site
    news_collection.title = "All News"
    news_collection.slug = "all-news"
    news_collection.fields[:contained_page_type].value = :next_chapter_blog_post
    news_collection.fields[:sort_attribute].value = "created_at"
    news_collection.fields[:sort_direction].value = "DESC"
    news_collection.published = false
    news_collection.locked = false
    news_collection.page_order_position = :last if news_collection.new_record?
    news_collection.save!

    news = (1..20).map do |index|
      title = "blog-post-#{index}"
      slug = slugify(title)
      news_item = Heracles::Sites::WheelerCentre::NextChapterBlogPost.find_or_initialize_by(url: "the-next-chapter/news/#{slug}")
      news_item.collection = news_collection
      news_item.parent = news_page
      news_item.site = site
      news_item.title = title
      news_item.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<div contenteditable=\"false\" insertable=\"pull_quote\" value='{\"quote\":\"At vero eos et accusam et justo duo dolores et ea rebum.\",\"display\":\"Left-aligned\"}'></div>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<div contenteditable=\"false\" insertable=\"image\" value='{\"id\":\"4bd217df-67c3-416e-a731-c4d51551dc79\",\"file_name\":\"2017-10-09-Juvenile-Detention---Keenan-Mundine.jpg\",\"content_type\":\"image/jpeg\",\"raw_width\":1600,\"raw_height\":1200,\"raw_orientation\":null,\"corrected_width\":1600,\"corrected_height\":1200,\"corrected_orientation\":\"landscape\",\"original_path\":\"a75/0c4/f1c/a750c4f1cf2f310af00f7557d2a3d15a9543e12a424a24029d3b30df93e5/2017-10-09-Juvenile-Detention---Keenan-Mundine.jpg\",\"original_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/a75/0c4/f1c/a750c4f1cf2f310af00f7557d2a3d15a9543e12a424a24029d3b30df93e5/2017-10-09-Juvenile-Detention---Keenan-Mundine.jpg\",\"size\":229110,\"title\":\"\",\"description\":\"\",\"attribution\":\"Illustration: Jon Tjhia\",\"tag_list\":[],\"processed\":true,\"created_at\":\"2017-10-09T19:18:27.609+11:00\",\"thumbnail_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/processed/6f/6598f0acca11e7a1a4d74cdb801e0b/70312650acca11e7b6d09d1e41da0603_heracles_admin_thumbnail.jpg\",\"preview_url\":\"https://wheeler-centre-heracles.s3.amazonaws.com/processed/6f/6598f0acca11e7a1a4d74cdb801e0b/70340c80acca11e7b2ec3fdd2fe0097b_heracles_admin_preview.jpg\",\"asset_id\":\"4bd217df-67c3-416e-a731-c4d51551dc79\",\"width\":\"\",\"display\":\"Right-aligned\"}'></div>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>\n<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>\n<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
      news_item.fields[:intro].value = "<p><em><a data-page-id=\"44e6cf22-dc48-44c8-9511-0ada993a5d9e\"><span>Michelle Scott Tucker</span></a> is the author of a new biography of the fascinating farming entrepreneur, Elizabeth Macarthur. She spoke with us about deadlines, dead ponies and derivative bush ballads written from deep suburbia. </em></p>"
      news_item.fields[:meta].value = "<p>Michelle Scott Tucker’s new book, <em>Elizabeth Macarthur: A Life at the Edge of the World</em>, will be released by Text Publishing in April 2018. It's a biography of a fascinating woman and does not describe the death of a pony.</p>"
      news_item.fields[:hero_image].asset_ids = [Heracles::Asset.where(content_type: "image/jpeg").order(created_at: :desc).limit(1000).map(&:id).sample]
      news_item.slug = slug
      news_item.published = true
      news_item.page_order_position = :last if news_item.new_record?
      news_item.save!
    end

    how_do_i_apply_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply")
    how_do_i_apply_page.parent = home_page
    how_do_i_apply_page.site = site
    how_do_i_apply_page.title = "How do I apply"
    how_do_i_apply_page.slug = "how-do-i-apply"
    how_do_i_apply_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    how_do_i_apply_page.published = true
    how_do_i_apply_page.locked = false
    how_do_i_apply_page.page_order_position = :last if how_do_i_apply_page.new_record?
    how_do_i_apply_page.save!

    key_dates_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/key-dates")
    key_dates_page.parent = how_do_i_apply_page
    key_dates_page.site = site
    key_dates_page.title = "Key dates"
    key_dates_page.slug = "key-dates"
    key_dates_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    key_dates_page.published = true
    key_dates_page.locked = false
    key_dates_page.page_order_position = :last if key_dates_page.new_record?
    key_dates_page.save!

    eligibility_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/eligibility")
    eligibility_page.parent = how_do_i_apply_page
    eligibility_page.site = site
    eligibility_page.title = "Eligibility"
    eligibility_page.slug = "eligibility"
    eligibility_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    eligibility_page.published = true
    eligibility_page.locked = false
    eligibility_page.page_order_position = :last if eligibility_page.new_record?
    eligibility_page.save!

    submit_an_application_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/submit-an-application-form")
    submit_an_application_page.parent = how_do_i_apply_page
    submit_an_application_page.site = site
    submit_an_application_page.title = "Submit an application form"
    submit_an_application_page.slug = "submit-an-application-form"
    submit_an_application_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    submit_an_application_page.published = true
    submit_an_application_page.locked = false
    submit_an_application_page.page_order_position = :last if submit_an_application_page.new_record?
    submit_an_application_page.save!

    nominate_somebody_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/nominate-somebody")
    nominate_somebody_page.parent = how_do_i_apply_page
    nominate_somebody_page.site = site
    nominate_somebody_page.title = "Nominate somebody"
    nominate_somebody_page.slug = "nominate-somebody"
    nominate_somebody_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    nominate_somebody_page.published = true
    nominate_somebody_page.locked = false
    nominate_somebody_page.page_order_position = :last if nominate_somebody_page.new_record?
    nominate_somebody_page.save!

    ## About us pages
    about_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/about-us")
    about_page.parent = home_page
    about_page.site = site
    about_page.title = "About us"
    about_page.slug = "about-us"
    about_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    about_page.published = true
    about_page.locked = false
    about_page.page_order_position = :last if about_page.new_record?
    about_page.save!

    contact_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/about-us/contact")
    contact_page.parent = about_page
    contact_page.site = site
    contact_page.title = "Contact"
    contact_page.slug = "contact"
    contact_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    contact_page.published = true
    contact_page.locked = false
    contact_page.page_order_position = :last if contact_page.new_record?
    contact_page.save!

    about_wc_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/about-us/about-the-wheeler-centre")
    about_wc_page.parent = about_page
    about_wc_page.site = site
    about_wc_page.title = "About the Wheeler Centre"
    about_wc_page.slug = "about-the-wheeler-centre"
    about_wc_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    about_wc_page.published = true
    about_wc_page.locked = false
    about_wc_page.page_order_position = :last if about_wc_page.new_record?
    about_wc_page.save!

    ## FAQs
    faqs_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/faqs")
    faqs_page.parent = home_page
    faqs_page.site = site
    faqs_page.title = "FAQs"
    faqs_page.slug = "faqs"
    faqs_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    faqs_page.published = true
    faqs_page.locked = false
    faqs_page.page_order_position = :last if faqs_page.new_record?
    faqs_page.save!
  end
end
