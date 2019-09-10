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

    # Broadside `event_series`
    broadsite_event_series = Heracles::Sites::WheelerCentre::EventSeries.find_or_initialize_by(url: "events/series/broadside")
    broadsite_event_series.parent = site.pages.find_by(url: "events/series")
    broadsite_event_series.collection = Heracles::Sites::WheelerCentre::Collection.find_by(url: "events/series/all-event-series")
    broadsite_event_series.site = site
    broadsite_event_series.title = "Broadside"
    broadsite_event_series.slug = "broadside"
    broadsite_event_series.published = true
    broadsite_event_series.locked = false
    broadsite_event_series.page_order_position = :last if broadsite_event_series.new_record?
    broadsite_event_series.save!

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

    people_collection = Heracles::Sites::WheelerCentre::Collection.find_by(url: "people/all-people")
    people = ["Aileen Moreton-Robinson", "Aminatou Sow", "Ariel Levy", "Caroline Martin", "Curtis Sittenfeld", "Fatima Bhutto", "Gala Vanting", "Helen Garner", "Intan Paramaditha", "Jan Fran", "Jax Jacki Brown", "Jia Tolentino", "Maria Tumarkin", "Michelle Law", "Mona Eltahawy", "Monica Lewinsky", "Nayuka Gorrie", "Nicole Kalms", "Nicole Lee", "Paola Balla", "Patricia Cornelius", "Raquel Willis", "Ruby Hamad", "Santilla Chingaipe", "Sarah Krasnostein", "Sophie Black", "Tressie McMillan Cottom", "Zadie Smith"]
    heracles_people = people.map do |person_name|
      first_name = person_name[0..(person_name =~ /\s/)-1]
      last_name = person_name[(person_name =~ /\s/)+1..-1]
      person = Heracles::Sites::WheelerCentre::Person.find_or_initialize_by(url: "people/#{slugify(person_name)}")
      if person.new_record?
        person.parent = Heracles::Sites::WheelerCentre::People.all.first
        person.collection = people_collection
        person.site = site
        person.title = person_name
        person.slug = slugify(person_name)
        person.published = true
        person.locked = false
        person.page_order_position = :last if person.new_record?
        person.fields[:first_name].value = first_name
        person.fields[:last_name].value = last_name
        person.fields[:twitter_name].value = "twitter"
        person.fields[:biography].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.</p><p>At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.</p><p>At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
        # person.fields[:portrait].asset_ids = [Heracles::Sites::WheelerCentre::Person.all.sample.fields[:portrait].try(:assets).try(:first).try(:id)]
        person.save!
      end
      person
    end

    people.each do |person_name|
      speaker_page = Heracles::Sites::WheelerCentre::BroadsideSpeakerPage.find_or_initialize_by(url: "broadside/who/#{slugify(person_name)}")
      speaker_page.parent = who_page
      speaker_page.site = site
      speaker_page.title = person_name
      speaker_page.slug = slugify(person_name)
      speaker_page.published = true
      speaker_page.locked = false
      speaker_page.page_order_position = :last if speaker_page.new_record?
      speaker_page.fields[:person].page_ids = [site.pages.find_by_url("people/#{slugify(person_name)}").id]
      speaker_page.save!
    end

    # Events
    events = [
      {
        title: "Helen Garner",
        start_date: "Sat, 9 Nov 2019 11:30:00",
        end_date: "Sat, 9 Nov 2019 12:30:00",
        type: "Spotlight",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Who Gave You Permission",
        start_date: "Sat, 9 Nov 2019 13:30:00" ,
        end_date: "Sat, 9 Nov 2019 14:30:00",
        type: "Panel",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Decolonising Feminism",
        start_date: "Sat, 9 Nov 2019 15:30:00",
        end_date: "Sat, 9 Nov 2019 16:30:00",
        type: "Panel",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Zadie Smith",
        start_date: "Sat, 9 Nov 2019 17:30:00",
        end_date: "Sat, 9 Nov 2019 18:30:00",
        type: "Spotlight",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Gala: Things My Mother Never Told Me",
        start_date: "Sat, 9 Nov 2019 19:30:00",
        end_date: "Sat, 9 Nov 2019 21:00:00",
        type: "Gala",
        price: "$50 adult<br>$40 concession",
      },
      {
        title: "Feminism Never Sleeps with Jan Fran",
        start_date: "Sat, 9 Nov 2019 22:00:00",
        end_date: "Sat, 9 Nov 2019 23:00:00",
        type: "Queerstories",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Taking Up Space: The City We Deserve",
        start_date: "Sun, 10 Nov 2019 10:00:00",
        end_date: "Sun, 10 Nov 2019 11:00:00",
        type: "Panel",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Tressie Mcmillan Cottom: Thick",
        start_date: "Sun, 10 Nov 2019 12:00:00",
        end_date: "Sun, 10 Nov 2019 13:00:00",
        type: "Spotlight",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Mona Eltahawy & Fatima Bhutto",
        start_date: "Sun, 10 Nov 2019 14:00:00",
        end_date: "Sun, 10 Nov 2019 15:00:00",
        type: "Panel",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Rage Against the Machine: Feminism & Capitalism",
        start_date: "Sun, 10 Nov 2019 16:00:00",
        end_date: "Sun, 10 Nov 2019 17:00:00",
        type: "Panel",
        price: "$30 adult<br>$25 concession",
      },
      {
        title: "Monica Lewinsky",
        start_date: "Sun, 10 Nov 2019 18:00:00",
        end_date: "Sun, 10 Nov 2019 19:00:00",
        type: "Spotlight",
        price: "$30 adult<br>$25 concession",
      }
    ]

    events_collection = Heracles::Sites::WheelerCentre::Collection.find_by(url: "events/all-events")
    events.each do |event_hash|
      event = Heracles::Sites::WheelerCentre::Event.find_or_initialize_by(url: "events/#{slugify(event_hash[:title])}")
      event.parent = Heracles::Sites::WheelerCentre::Events.all.first
      event.collection = events_collection
      event.site = site
      event.title = event_hash[:title]
      event.slug = slugify(event_hash[:title])
      event.published = true
      event.locked = false
      event.page_order_position = :last if event.new_record?
      event.fields[:start_date].value = event_hash[:start_date]
      event.fields[:start_date].time_zone = "Melbourne"
      event.fields[:end_date].value = event_hash[:end_date]
      event.fields[:end_date].time_zone = "Melbourne"
      event.fields[:series].page_ids = [broadsite_event_series.id]
      event.fields[:broadside_type].value = event_hash[:type]
      event.fields[:ticket_prices].value = event_hash[:price]
      event.fields[:body].value = "<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.</p><p>At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.</p><p>At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>"
      event.fields[:venue].page_ids = [site.pages.find_by(url: "events/venues/melbourne-town-hall").id]
      event.fields[:presenters].page_ids = heracles_people.sample((1..4).to_a.sample).map(&:id)
      event.save!
    end

    # `broadside_event_pages`
    events.each do |event_hash|
      event_page = Heracles::Sites::WheelerCentre::BroadsideEventPage.find_or_initialize_by(url: "broadside/#{slugify(event_hash[:title])}")
      event_page.parent = Heracles::Sites::WheelerCentre::BroadsideHomePage.all.first
      event_page.site = site
      event_page.title = event_hash[:title]
      event_page.slug = slugify(event_hash[:title])
      event_page.published = true
      event_page.locked = false
      event_page.page_order_position = :last if event_page.new_record?
      event_page.fields[:event].page_ids = [site.pages.find_by_url("events/#{slugify(event_hash[:title])}").id]
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
        title: "About Broadside",
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
        title: "Tickets, packages and deals",
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
        title: "Donate",
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
      page.save!
    end
  end
end
