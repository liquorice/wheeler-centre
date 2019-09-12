def slugify(name)
  name.downcase.gsub(/\&/, "and").gsub(/[^a-zA-Z0-9]/, ' ').gsub(/\s+/, '-')
end

namespace :temporary do
  desc "Set up broadside microsite pages"
  task setup_broadside: :environment do

    if Rails.env != "development"
      raise "Currently set to run in development only. Double check everything before running in production."
    end

    site = Heracles::Site.first

    home_page = Heracles::Sites::WheelerCentre::BroadsideHomePage.find_or_initialize_by(url: "broadside")
    home_page.site = site
    home_page.title = "Broadside"
    home_page.slug = "broadside"
    home_page.published = true
    home_page.locked = true
    home_page.page_order_position = :last if home_page.new_record?
    home_page.save!

    # When page
    when_page = Heracles::Sites::WheelerCentre::BroadsideWhenPage.find_or_initialize_by(url: "broadside/when")
    when_page.parent = home_page
    when_page.site = site
    when_page.title = "When"
    when_page.slug = "when"
    when_page.published = true
    when_page.locked = false
    when_page.page_order_position = :last if when_page.new_record?
    when_page.save!

    # Who page
    who_page = Heracles::Sites::WheelerCentre::BroadsideWhoPage.find_or_initialize_by(url: "broadside/who")
    who_page.parent = home_page
    who_page.site = site
    who_page.title = "Who"
    who_page.slug = "who"
    who_page.published = true
    who_page.locked = false
    who_page.page_order_position = :last if who_page.new_record?
    who_page.save!

    events = Heracles::Page.of_type(:event).where("(fields_data#>'{series, page_ids}')::jsonb ?| ARRAY[:page_ids]", page_ids: "3a3888db-bf79-4f6c-9a67-c51f06d33ac3")
    people = events.map { |event| event.fields[:presenters].page_ids }.flatten.uniq.map { |id| Heracles::Page.find(id) }
    people.each do |person|
      person_name = person.title
      speaker_page = Heracles::Sites::WheelerCentre::BroadsideSpeakerPage.find_or_initialize_by(url: "broadside/who/#{slugify(person_name)}")
      speaker_page.parent = who_page
      speaker_page.site = site
      speaker_page.title = person_name
      speaker_page.slug = slugify(person_name)
      speaker_page.published = true
      speaker_page.locked = false
      speaker_page.page_order_position = :last if speaker_page.new_record?
      speaker_page.fields[:person].page_ids = [person.id]
      speaker_page.save!
    end

    events.each do |event|
      event_page = Heracles::Sites::WheelerCentre::BroadsideEventPage.find_or_initialize_by(url: "broadside/#{slugify(event.title)}")
      event_page.parent = Heracles::Sites::WheelerCentre::BroadsideHomePage.all.first
      event_page.site = site
      event_page.title = event.title
      event_page.slug = slugify(event.title)
      event_page.published = true
      event_page.locked = false
      event_page.page_order_position = :last if event_page.new_record?
      event_page.fields[:event].page_ids = [event.id]
      event_page.save!
    end

    # Redirects from the WC event pages to the broadside event pages
    events.each do |event_hash|
      redirect = Heracles::Redirect.find_or_initialize_by(source_url: "/events/#{slugify(event_hash[:title])}")
      redirect.source_url = "/events/#{slugify(event_hash[:title])}"
      redirect.target_url = "/broadside/#{slugify(event_hash[:title])}"
      redirect.site = site
      redirect.save!
    end

    content_pages = [
      {
        slug: "what",
        title: "What",
        alternative_title: "About broadside",
        url: "broadside/what"
      },
      {
        slug: "about-the-wheeler-centre",
        title: "About the Wheeler Centre",
        url: "broadside/what/about-the-wheeler-centre"
      },
      {
        slug: "faq",
        title: "FAQ",
        url: "broadside/what/faq"
      },
      {
        slug: "privacy-policy",
        title: "Privacy policy",
        url: "broadside/what/privacy-policy"
      },
      {
        slug: "how",
        title: "How",
        alternative_title: "Tickets, packages and deals",
        template: "tickets_page.html.slim",
        url: "broadside/how"
      },
      {
        slug: "getting-there",
        title: "Getting there",
        url: "broadside/how/getting-there"
      },
      {
        slug: "what-s-nearby",
        title: "What's nearby",
        url: "broadside/how/what-s-nearby"
      },
      {
        slug: "accessibility",
        title: "Accessibility",
        url: "broadside/how/accessibility"
      },
      {
        slug: "terms-and-conditions",
        title: "Terms and conditions",
        url: "broadside/how/terms-and-conditions"
      },
      {
        slug: "support",
        title: "Support",
        alternative_title: "Donate",
        url: "broadside/support"
      },
      {
        slug: "supporters-partners",
        title: "Supporters / partners",
        url: "broadside/support/supporters-partners"
      },
      {
        slug: "stay-in-touch",
        title: "Stay in touch",
        url: "broadside/support/stay-in-touch"
      },
    ]

    # content pages
    def count_em(str, target)
      target.chars.uniq.map { |c| str.count(c)/target.count(c) }.min
    end
    content_pages.each do |content_page|
      page = Heracles::Sites::WheelerCentre::BroadsideContentPage.find_or_initialize_by(url: content_page[:url])
      if count_em(content_page[:url], "/") > 1
        path = content_page[:url][0..content_page[:url].rindex("/")-1]
        parent = Heracles::Page.find_by(url: path)
      else
        parent = Heracles::Sites::WheelerCentre::BroadsideHomePage.all.first
      end
      page.parent = parent
      page.site = site
      page.title = content_page[:title]
      page.slug = content_page[:slug]
      page.published = true
      page.locked = false
      page.page_order_position = :last if page.new_record?
      page.fields[:alternative_title].value = content_page[:alternative_title] if content_page[:alternative_title]
      page.template = content_page[:template] if content_page[:template]
      page.save!
    end
  end
end
