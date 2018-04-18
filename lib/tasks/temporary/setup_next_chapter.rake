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
    what_is_the_next_chapter_page.locked = true
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
    meet_the_writers_page.locked = true
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
    meet_the_writers_2018_page.locked = true
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
    meet_the_readers_page.locked = true
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
    meet_the_readers_2018_page.locked = true
    meet_the_readers_2018_page.page_order_position = :last if meet_the_readers_2018_page.new_record?
    meet_the_readers_2018_page.save!

    # News...
    # news_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/news")
    # news_page.parent = home_page
    # news_page.site = site
    # news_page.title = "News"
    # news_page.slug = "news"
    # news_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    # news_page.published = true
    # news_page.locked = true
    # news_page.page_order_position = :last if news_page.new_record?
    # news_page.save!

    how_do_i_apply_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply")
    how_do_i_apply_page.parent = home_page
    how_do_i_apply_page.site = site
    how_do_i_apply_page.title = "How do I apply"
    how_do_i_apply_page.slug = "how-do-i-apply"
    how_do_i_apply_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    how_do_i_apply_page.published = true
    how_do_i_apply_page.locked = true
    how_do_i_apply_page.page_order_position = :last if how_do_i_apply_page.new_record?
    how_do_i_apply_page.save!

    key_dates_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/key-dates")
    key_dates_page.parent = how_do_i_apply_page
    key_dates_page.site = site
    key_dates_page.title = "Key dates"
    key_dates_page.slug = "key-dates"
    key_dates_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    key_dates_page.published = true
    key_dates_page.locked = true
    key_dates_page.page_order_position = :last if key_dates_page.new_record?
    key_dates_page.save!

    eligibility_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/eligibility")
    eligibility_page.parent = how_do_i_apply_page
    eligibility_page.site = site
    eligibility_page.title = "Eligibility"
    eligibility_page.slug = "eligibility"
    eligibility_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    eligibility_page.published = true
    eligibility_page.locked = true
    eligibility_page.page_order_position = :last if eligibility_page.new_record?
    eligibility_page.save!

    submit_an_application_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/submit-an-application-form")
    submit_an_application_page.parent = how_do_i_apply_page
    submit_an_application_page.site = site
    submit_an_application_page.title = "Submit an application form"
    submit_an_application_page.slug = "submit-an-application-form"
    submit_an_application_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    submit_an_application_page.published = true
    submit_an_application_page.locked = true
    submit_an_application_page.page_order_position = :last if submit_an_application_page.new_record?
    submit_an_application_page.save!

    nominate_somebody_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/how-do-i-apply/nominate-somebody")
    nominate_somebody_page.parent = how_do_i_apply_page
    nominate_somebody_page.site = site
    nominate_somebody_page.title = "Nominate somebody"
    nominate_somebody_page.slug = "nominate-somebody"
    nominate_somebody_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    nominate_somebody_page.published = true
    nominate_somebody_page.locked = true
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
    about_page.locked = true
    about_page.page_order_position = :last if about_page.new_record?
    about_page.save!

    contact_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/about-us/contact")
    contact_page.parent = about_page
    contact_page.site = site
    contact_page.title = "Contact"
    contact_page.slug = "contact"
    contact_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    contact_page.published = true
    contact_page.locked = true
    contact_page.page_order_position = :last if contact_page.new_record?
    contact_page.save!

    about_wc_page = Heracles::Sites::WheelerCentre::NextChapterContentPage.find_or_initialize_by(url: "the-next-chapter/about-us/about-the-wheeler-centre")
    about_wc_page.parent = about_page
    about_wc_page.site = site
    about_wc_page.title = "About the Wheeler Centre"
    about_wc_page.slug = "about-the-wheeler-centre"
    about_wc_page.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.</p>\n<p>Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
    about_wc_page.published = true
    about_wc_page.locked = true
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
    faqs_page.locked = true
    faqs_page.page_order_position = :last if faqs_page.new_record?
    faqs_page.save!
  end
end
