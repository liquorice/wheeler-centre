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
  end
end
