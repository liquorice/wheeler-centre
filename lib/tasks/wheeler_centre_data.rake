namespace :wheeler_centre do
  desc "Import blueprint sponsors"
  task :import_blueprint_sponsors, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_sponsors = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtSponsor }
    heracles_sponsors_index = Heracles::Page.where(url: "sponsors").first!
    heracles_sponsors_collection = heracles_sponsors_index.children.of_type("collection").where(slug: "all-sponsors").first!

    blueprint_sponsors.each do |blueprint_sponsor|
      if blueprint_sponsor["title"].present?
        heracles_sponsor = Heracles::Sites::WheelerCentre::Sponsor.find_by_slug(blueprint_sponsor["slug"])
        unless heracles_sponsor
          heracles_sponsor = Heracles::Page.new_for_site_and_page_type(heracles_sponsors_index.site, "sponsor")
        end
        heracles_sponsor.slug = blueprint_sponsor["slug"]
        heracles_sponsor.title = blueprint_sponsor["title"]
        heracles_sponsor.created_at = Time.zone.parse(Time.now.to_s)
        heracles_sponsor.site = heracles_sponsors_index.site
        heracles_sponsor.parent = heracles_sponsors_index
        heracles_sponsor.collection = heracles_sponsors_collection
        heracles_sponsor.published = true
        heracles_sponsor.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_sponsor["content"], subject: blueprint_sponsor, assetify: false)
        if blueprint_sponsor["url"].present? then heracles_sponsor.fields[:url].value = blueprint_sponsor["url"].to_s end
        if blueprint_sponsor["id"].present? then heracles_sponsor.fields[:sponsor_id].value = blueprint_sponsor["id"].to_i end
        # {name: :logo, type: :asset, asset_file_type: :image}
        heracles_sponsor.save!
      end
    end

  end

  desc "Import blueprint event series"
  task :import_blueprint_event_series, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_event_series = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtProgram }
    heracles_events_index = Heracles::Page.where(url: "events").first!
    heracles_events_series_collection = heracles_events_index.children.of_type("collection").where(slug: "all-event-series").first!

    blueprint_event_series.each do |blueprint_series|
      if blueprint_series["name"].present?
        heracles_series = Heracles::Sites::WheelerCentre::EventSeries.find_by_slug(blueprint_series["slug"])
        unless heracles_series
          heracles_series = Heracles::Page.new_for_site_and_page_type(heracles_events_index.site, "event_series")
          heracles_series.parent = heracles_events_index
          heracles_series.collection = heracles_events_series_collection
        end

        heracles_series.published = true
        heracles_series.title = blueprint_series["name"]
        heracles_series.slug = blueprint_series["slug"]
        puts (blueprint_series["slug"])
        heracles_series.created_at = Time.zone.parse(blueprint_series["created_on"].to_s)
        if blueprint_series["content"].present? then heracles_series.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_series["content"], subject: blueprint_series, assetify: false) end
        if blueprint_series["id"].present?
          puts (blueprint_series["id"])
          heracles_series.fields[:series_id].value = blueprint_series["id"].to_i
        end
        heracles_series.fields[:archived].value = true
        # {name: :promo_image, type: :asset, asset_file_type: :image},
        heracles_series.save!
      end
    end

  end

  desc "Import blueprint events"
  task :import_blueprint_events, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_events = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtEvent}
    blueprint_sponsorships = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtSponsorship }
    heracles_events_index = Heracles::Page.where(url: "events").first!
    heracles_events_collection = heracles_events_index.children.of_type("collection").where(slug: "all-events").first!

    all_series = Heracles::Page.of_type("event_series")
    all_sponsors = Heracles::Page.of_type("sponsor")

    blueprint_events.each do |blueprint_event|
      # Find an existing event
      heracles_event = heracles_events_index.children.of_type("event").find_by_slug(blueprint_event["slug"])

      # Or build a new one
      unless heracles_event
        heracles_event = Heracles::Page.new_for_site_and_page_type(heracles_events_index.site, "event")
        heracles_event.parent = heracles_events_index
        heracles_event.collection = heracles_events_collection
        heracles_event.slug = blueprint_event["slug"]
      end

      heracles_event.published = true
      heracles_event.title = blueprint_event["title"]
      puts (blueprint_event["slug"])
      heracles_event.created_at = Time.zone.parse(blueprint_event["created_on"].to_s)
      heracles_event.fields[:short_title].value = blueprint_event["short_title"].to_s
      heracles_event.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_event["content"], subject: blueprint_event, assetify: false)
      heracles_event.fields[:start_date].value = Time.zone.parse(blueprint_event["start_date"].to_s)
      heracles_event.fields[:end_date].value = Time.zone.parse(blueprint_event["end_date"].to_s)
      heracles_event.fields[:venue].value = blueprint_event["venue"].to_s
      heracles_event.fields[:external_bookings].value = blueprint_event["booking_service_url"].to_s
      heracles_event.fields[:bookings_open_at].value = Time.zone.parse(blueprint_event["public_bookings_open_at"].to_s)

      event_series = all_series.select { |p| p.fields[:series_id].value.to_i == blueprint_event["program_id"].to_i }
      if event_series.present?
        heracles_event.fields[:series].page_ids = event_series.map(&:id)
      end

      # Find all the sponsors for this event and add them to the sponsors field on this event
      # This mirrors the data as it was in Blueprint, where the relationship was between events and sponsors
      event_sponsorships = find_matching_event_sponsorships(blueprint_event, blueprint_sponsorships)
      if event_sponsorships.present?
        sponsor_ids = event_sponsorships.map { |p| p["sponsor_id"].to_i }
        puts (sponsor_ids)
        sponsors = all_sponsors.select { |p| sponsor_ids.include?(p.fields[:sponsor_id].value.to_i) }
        if sponsors.present? then heracles_event.fields[:sponsors].page_ids = sponsors.map(&:id) end
      end

      heracles_event.save!
    end
  end

  desc "Import Blueprint People"
  task :import_blueprint_people, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_presenters = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtPresenter }
    blueprint_users = blueprint_records.select { |r| r.class == LegacyBlueprint::User }
    blueprint_staff = blueprint_records.select { |r| r.class == LegacyBlueprint::PslPerson }

    blueprint_presenters.each do |blueprint_presenter|
      heracles_person = Heracles::Sites::WheelerCentre::Person.find_by_slug(blueprint_presenter["slug"])
      unless heracles_person then heracles_person = Heracles::Page.new_for_site_and_page_type(site, "person") end
      heracles_person.published = true
      heracles_person.slug = blueprint_presenter["slug"]
      heracles_person.title = blueprint_presenter["name"]
      heracles_person.fields[:intro].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_presenter["intro"], subject: blueprint_presenter, assetify: false)
      heracles_person.fields[:biography].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_presenter["bio"], subject: blueprint_presenter, assetify: false)
      heracles_person.fields[:url].value = blueprint_presenter["url"]
      heracles_person.fields[:external_links].value = blueprint_presenter["external_links"]
      # TODO:
      # {name: :portrait, type: :asset, asset_file_type: :image},
      # {name: :reviews, type: :content},
      # Find a staff member that matches this presenter
      staff_member = find_matching_staff_member(blueprint_presenter, blueprint_staff)
      if staff_member.present?
        puts (staff_member["slug"])
        heracles_person.fields[:is_staff_member].value = true
        heracles_person.fields[:staff_bio].value = LegacyBlueprint::BluedownFormatter.mark_up(staff_member["bio"], subject: staff_member, assetify: false)
        heracles_person.fields[:position_title].value = staff_member["title"]
        heracles_person.fields[:first_name].value = staff_member["first_name"]
        heracles_person.fields[:last_name].value = staff_member["surname"]
      else
        # We still need to split the name and assign to first_name and last_name
        names = blueprint_presenter["name"].split(" ")
        # Simply make the first component of the name the first_name
        heracles_person.fields[:first_name].value = names.first
        # Make everything else the last_name
        heracles_person.fields[:last_name].value = names.drop(1).join(" ")
      end
      # Find a matching user and set the id
      user = find_matching_user(blueprint_presenter, blueprint_users)
      if user.present?
        puts (user["id"])
        heracles_person.fields[:user_id].value = user["id"]
      end
      heracles_person.created_at = Time.zone.parse(blueprint_presenter["created_on"].to_s)
      heracles_person.parent = Heracles::Page.find_by_slug("people")
      heracles_person.collection = Heracles::Page.where(url: "people/all-people").first!
      puts (heracles_person.slug)
      heracles_person.save!
    end

    blueprint_users.each do |blueprint_user|
      if blueprint_user["name"].present?
        # Make a best effort to construct the slug, as we only have `name` to go by
        slug = blueprint_user["name"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        names = blueprint_user["name"].split(" ")
        existing_heracles_person = Heracles::Sites::WheelerCentre::Person.find_by_slug(slug)
        unless existing_heracles_person
          # Only create a new person if that slug doesn't already exist
          heracles_person = Heracles::Page.new_for_site_and_page_type(site, "person")
          heracles_person.published = true
          heracles_person.slug = slug
          unless blueprint_user["name"] then heracles_person.title = blueprint_user["name"] else heracles_person.title = slug end
          heracles_person.fields[:first_name].value = names.first
          heracles_person.fields[:last_name].value = names.drop(1).join(" ")
          heracles_person.fields[:user_id].value = blueprint_user["id"]
          heracles_person.created_at = Time.zone.parse(blueprint_user["created_on"].to_s)
          heracles_person.parent = Heracles::Page.find_by_slug("people")
          heracles_person.collection = Heracles::Page.where(url: "people/all-people").first!
          heracles_person.save!
        end
      end
    end

    blueprint_staff.each do |blueprint_staff_member|
      existing_heracles_person = Heracles::Sites::WheelerCentre::Person.find_by_slug(blueprint_staff_member["slug"])
      unless existing_heracles_person
        heracles_person = Heracles::Page.new_for_site_and_page_type(site, "person")
        heracles_person.published = true
        heracles_person.slug = blueprint_staff_member["slug"]
        heracles_person.title = blueprint_staff_member["first_name"] + " " + blueprint_staff_member["surname"]
        heracles_person.fields[:is_staff_member].value = true
        heracles_person.fields[:staff_bio].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_staff_member["bio"], subject: blueprint_staff_member, assetify: false)
        heracles_person.fields[:position_title].value = blueprint_staff_member["title"]
        heracles_person.fields[:first_name].value = blueprint_staff_member["first_name"]
        heracles_person.fields[:last_name].value = blueprint_staff_member["surname"]
        heracles_person.created_at = Time.zone.parse(blueprint_staff_member["created_on"].to_s)
        heracles_person.parent = Heracles::Page.find_by_slug("people")
        heracles_person.collection = Heracles::Page.where(url: "people/all-people").first!
        heracles_person.save!
      end
    end

  end

  desc "Import Blueprint Dailies"
  task :import_blueprint_dailies, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    dailies_root = blueprint_records.select { |r| r.class == LegacyBlueprint::TumPage && r["slug"] == "dailies" }
    id = dailies_root.first["id"].to_i

    blueprint_dailies = blueprint_records.select { |r| r.class == LegacyBlueprint::TumArticle && r["page_id"].to_i == id }
    all_authors = Heracles::Page.of_type("person")
    parent = Heracles::Page.find_by_slug("writings")
    collection = Heracles::Page.where(url: "writings/all-writings").first!

    blueprint_dailies.each do |blueprint_daily|
      if blueprint_daily["title"].present?
        heracles_blog_post = Heracles::Page.find_by_slug(blueprint_daily["slug"])
        unless heracles_blog_post then heracles_blog_post = Heracles::Page.new_for_site_and_page_type(site, "blog_post") end
        heracles_blog_post.published = true
        heracles_blog_post.slug = blueprint_daily["slug"]
        heracles_blog_post.title = blueprint_daily["title"]

        content = blueprint_daily["content"].to_s
        # Split the summary out on the highlight tag
        summary = content.split("[[highlight]]")
        if summary.length > 0
          content.slice!(summary[0])
          heracles_blog_post.fields[:summary].value = LegacyBlueprint::BluedownFormatter.mark_up(summary[0], subject: blueprint_daily, assetify: false)
          heracles_blog_post.fields[:intro].value = LegacyBlueprint::BluedownFormatter.mark_up(summary[0], subject: blueprint_daily, assetify: false)
        end
        heracles_blog_post.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(content, subject: blueprint_daily, assetify: false)
        heracles_blog_post.created_at = Time.zone.parse(blueprint_daily["created_on"].to_s)
        heracles_blog_post.parent = parent
        heracles_blog_post.collection = collection
        authors = all_authors.select { |p| p.fields[:user_id].value.to_i == blueprint_daily["user_id"].to_i }
        if authors.present?
          heracles_blog_post.fields[:authors].page_ids = authors.map(&:id)
        end
        heracles_blog_post.save!
      end
    end
  end

  desc "Import blueprint types that map to Page"
  task :import_blueprint_types_to_page, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_pages = blueprint_records.select { |r| r.class == LegacyBlueprint::Page || r.class == LegacyBlueprint::FaqPage || r.class == LegacyBlueprint::PslPage || r.class == LegacyBlueprint::CttPage || r.class == LegacyBlueprint::DbyPage || r.class == LegacyBlueprint::DirPage}

    blueprint_pages.each do |blueprint_page|
      # If a parent page is set in the yaml, find it and use it as the Heracles parent
      if blueprint_page["parent_page"].present?
        parent = Heracles::Page.find_by_slug(blueprint_page["parent_page"])
      end

      slug_components = blueprint_page["slug"].split("/")
      if slug_components.length > 1
        # Set the slug to be the last part of the blueprint slug
        slug = slug_components.last
        puts ("Slug: #{slug}" )
        # Find the closest parent page
        slug_components.reverse.each_with_index do |slug_component, index|
          if index > 0
            puts ("slug_component: #{slug_component}")
            parent = Heracles::Page.find_by_slug(slug_component)
            puts ("Parent: #{parent}")
          end
        end
      end

      if !slug.present?
        slug = blueprint_page["slug"]
      end

      heracles_page = Heracles::Sites::WheelerCentre::ContentPage.find_by_slug(slug)

      unless heracles_page
        site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
        heracles_page = Heracles::Page.new_for_site_and_page_type(site, "content_page")
        if parent.present?
          heracles_page.parent = parent
        end
      end

      heracles_page.published = true
      heracles_page.slug = slug
      heracles_page.title = blueprint_page["title"]
      heracles_page.created_at = Time.zone.parse(blueprint_page["created_on"].to_s)
      heracles_page.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_page["content"], subject: blueprint_page, assetify: false)
      heracles_page.save!
    end
  end

  # Example use: rake wheeler_centre:import_blueprint_types_to_body["/Users/josephinehall/Development/wheeler-centre/backup.yml","faq","FaqQuestion"]
  desc "Import blueprint types to a page body field"
  task :import_blueprint_types_to_body, [:yml_file, :page_slug, :type] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    YAML::ENGINE.yamler = 'syck'
    blueprint_records = YAML.load_stream(backup_data).instance_variable_get(:@documents)
    parent = Heracles::Sites::WheelerCentre::ContentPage.find_by_slug(args[:page_slug])
    body = ""

    if args[:type] == "FaqQuestion"
      blueprint_types = blueprint_records.select { |r| r.class == LegacyBlueprint::FaqQuestion }
      blueprint_types.map do |type|
        # TODO probably need to put some formatting or styling around each question for FAQs?
        body << LegacyBlueprint::BluedownFormatter.mark_up(type["question"], subject: type, assetify: false)
        body << LegacyBlueprint::BluedownFormatter.mark_up(type["answer"], subject: type, assetify: false)
      end
    end

    if parent.present?
      parent.fields[:body].value = body
      parent.save!
    end
  end

  desc "Import blueprint legacy 'Criticism Now' pages"
  task :import_blueprint_criticism_now, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!

    # Find or initialise the Projects page
    projects = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "projects")
    projects.site = site
    projects.title = "Projects"
    projects.slug = "projects"
    projects.published = true
    projects.save!
    # Find or initialise the Criticism page
    criticism_now = Heracles::Sites::WheelerCentre::ContentPage.find_or_initialize_by(url: "projects/criticism-now")
    criticism_now.site = site
    criticism_now.title = "Criticism Now"
    criticism_now.slug = "criticism-now"
    criticism_now.published = true
    criticism_now.parent = projects
    criticism_now.save!

    blueprint_pages = blueprint_records.select { |r| r.class == LegacyBlueprint::TumPage }

    blueprint_pages.each do |blueprint_page|
      # The Dailies TumPage isn't part of "Criticism Now"
      unless blueprint_page["slug"] == "dailies"
        slug_components = blueprint_page["slug"].split("/")
        if slug_components.length > 1
          # Set the slug to be the last part of the blueprint slug
          slug = slug_components.last
        end

        if !slug.present?
          slug = blueprint_page["slug"]
        end

        heracles_page = Heracles::Sites::WheelerCentre::ContentPage.find_by_slug(slug)

        unless heracles_page
          site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
          heracles_page = Heracles::Page.new_for_site_and_page_type(site, "content_page")
          if criticism_now.present?
            heracles_page.parent = criticism_now
          end
        end

        heracles_page.published = true
        heracles_page.slug = slug
        heracles_page.title = blueprint_page["title"]
        heracles_page.created_at = Time.zone.parse(blueprint_page["created_on"].to_s)
        heracles_page.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_page["content"], subject: blueprint_page, assetify: false)
        heracles_page.save!

        reviews_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: heracles_page.url + "/all-reviews")
        reviews_collection.parent = heracles_page
        reviews_collection.site = site
        reviews_collection.fields[:contained_page_type].value = "review"
        reviews_collection.fields[:sort_attribute].value = "created_at"
        reviews_collection.fields[:sort_direction].value = "DESC"
        reviews_collection.title = "All Reviews"
        reviews_collection.slug = "all-reviews"
        reviews_collection.save!

        responses_collection = Heracles::Sites::WheelerCentre::Collection.find_or_initialize_by(url: heracles_page.url + "/all-responses")
        responses_collection.parent = heracles_page
        responses_collection.site = site
        responses_collection.fields[:contained_page_type].value = "response"
        responses_collection.fields[:sort_attribute].value = "created_at"
        responses_collection.fields[:sort_direction].value = "DESC"
        responses_collection.title = "All Responses"
        responses_collection.slug = "all-responses"
        responses_collection.save!

        id = blueprint_page["id"].to_i

        # TODO: do we need to handle the TumWidget type?
        # Find all the Tum{#types} that have the id as their page_id, and sort them into collections
        if id.present?
          blueprint_reviews = blueprint_records.select { |r| r.class == LegacyBlueprint::TumArticle && r["page_id"].to_i == id }
          blueprint_reviews.each do |blueprint_review|
            heracles_review = Heracles::Page.find_by_slug(blueprint_review["slug"])
            unless heracles_review then heracles_review = Heracles::Page.new_for_site_and_page_type(site, "review") end
            heracles_review.published = true
            heracles_review.slug = blueprint_review["slug"]
            heracles_review.title = blueprint_review["title"]
            heracles_review.created_at = Time.zone.parse(blueprint_review["created_on"].to_s)
            heracles_review.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_review["content"], subject: blueprint_review, assetify: false)
            heracles_review.parent = heracles_page
            heracles_review.collection = reviews_collection
            heracles_review.save!
          end

          blueprint_responses = blueprint_records.select { |r| r.class == LegacyBlueprint::TumQuote && r["page_id"].to_i == id }
          blueprint_responses.each do |blueprint_response|
            heracles_response = Heracles::Page.find_by_slug(blueprint_response["slug"])
            unless heracles_response then heracles_response = Heracles::Page.new_for_site_and_page_type(site, "response") end
            heracles_response.published = true
            heracles_response.slug = blueprint_response["slug"]
            # Trim the title to the first few words
            heracles_response.title = blueprint_response["title"][0..30].gsub(/\s\w+\s*$/, '...')
            # Map the Blueprint fields to better-named fields in Heracles.
            heracles_response.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_response["title"], subject: blueprint_response, assetify: false)
            # The author is stored in the content field
            heracles_response.fields[:author].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_response["content"], subject: blueprint_response, assetify: false)
            heracles_response.fields[:url].value = blueprint_response["url"]
            heracles_response.created_at = Time.zone.parse(blueprint_response["created_on"].to_s)
            heracles_response.parent = heracles_page
            heracles_response.collection = responses_collection
            heracles_response.save!
          end
        end
      end
    end
  end

  # Usage:
  # rake wheeler_centre:import_blueprint_recordings["/Users/josephinehall/Development/wheeler-centre/backup.yml","video.wheelercentre.com","/Users/josephinehall/Development/wheeler-centre/lib/video_migration/config.yml"]
  desc "Import legacy Blueprint 'CenvidPost' content to be Recordings"
  task :import_blueprint_recordings, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"
    require "video_migration/s3_util"
    require "video_migration/ec2_util"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)
    blueprint_video_posts = blueprint_records.select { |r| r.class == LegacyBlueprint::CenvidPost }

    site = Heracles::Site.where(slug: HERACLES_SITE_SLUG).first!
    parent = Heracles::Page.find_by_slug("broadcasts")
    collection = Heracles::Page.where(url: "broadcasts/all-recordings").first!

    blueprint_video_posts.each do |blueprint_video_post|
      if blueprint_video_post["title"].present?
        heracles_recording = Heracles::Sites::WheelerCentre::Recording.find_by_slug(blueprint_video_post["slug"])
        unless heracles_recording then heracles_recording = Heracles::Page.new_for_site_and_page_type(site, "recording") end
        heracles_recording.published = true
        puts (blueprint_video_post["slug"])
        heracles_recording.slug = blueprint_video_post["slug"]
        heracles_recording.title = blueprint_video_post["title"]
        heracles_recording.fields[:short_title].value = blueprint_video_post["title"]
        heracles_recording.fields[:description].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_video_post["description"], subject: blueprint_video_post, assetify: false)
        heracles_recording.fields[:transcripts].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_video_post["transcript"], subject: blueprint_video_post, assetify: false)
        # # TODO :audio
        # # TODO :promo_image
        # # TODO check :publish_at?
        heracles_recording.fields[:recording_date].value = Time.zone.parse(blueprint_video_post["event_date"].to_s)
        heracles_recording.created_at = Time.zone.parse(blueprint_video_post["created_on"].to_s)
        heracles_recording.fields[:recording_id].value = blueprint_video_post["id"].to_i
        heracles_recording.parent = parent
        heracles_recording.collection = collection
        heracles_recording.save!
      end
    end
  end

  desc "Migrate videos to Youtube"
  task :migrate_videos, [:yml_file, :bucket_name, :video_config_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "video_migration/s3_util"
    require "video_migration/ec2_util"

    backup_data = File.read(args[:yml_file])
    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    blueprint_videos = blueprint_records.select { |r| r.class == LegacyBlueprint::CenvidVideo }
    recordings = Heracles::Page.of_type("recording")

    s3_util = S3Util.new(bucket_name: args[:bucket_name], config_file: args[:video_config_file])
    ec2_util = EC2Util.new(config_file: args[:video_config_file])

    # TODO create as many instances as recordings

    recordings.each do |recording|
      # Find Videos that match a given Recording's :recording_id
      videos = find_matching_videos(blueprint_videos, recording.fields[:recording_id].value)

      if videos.present?
        # Order the video by their encoding formats
        ordered_videos = encoding_formats.map! do |format|
          videos.find { |r| r["encoding_format"].to_s == format.to_s }
        end
        best_video = ordered_videos.find { |x| not x.nil? }

        puts (best_video)

        if best_video["dest_filename"]
          # Find the file in the S3 Bucket
          public_url = s3_util.find_video(best_video["dest_filename"].to_s)
          ec2_util.create_instance
          ec2_util.create_scripts(best_video["dest_filename"].to_s, public_url, recording)
          ec2_util.transfer_scripts
          ec2_util.execute_scripts

          youtube_url = ec2_util.get_youtube_url

          migration_record = {
            :id => recording.id,
            :slug => recording.slug,
            :recording_id => recording.fields[:recording_id].value,
            :youtube_url => youtube_url
          }

          File.open("youtube_migrations.json", "a") do |file|
            record = JSON.dump(migration_record)
            file << record
          end

          recording.fields[:url].value = youtube_url
          ec2_util.terminate_instance

        end
      end
    end

  end

  def find_matching_videos(data, recording_id)
    data.select { |r| r["post_id"].to_i == recording_id.to_i }
  end

  def encoding_formats
    [
      "Flash MP4 432p CBWI 800",
      "Flash MP4 432p CBWI 400",
      "Flash MP4 432p CBWI 200",
      "Flash MP4 432p CBWI",
      "Flash MP4 288p CBWI 800",
      "Flash MP4 288p CBWI 600",
      "Flash MP4 288p CBWI 400",
      "Flash MP4 288p CBWI 200",
      "Flash MP4 288p CBWI",
      "Flash Video 288p CBWI",
      "Flash MP4 288p CBWI TEST",
      "Flash Video 288p CBWI TEST",
      "MP3 CBWI",
    ]
  end

  def find_matching_staff_member(presenter, data)
    # The best we can do is match on the slug, or maybe the names.
    staff = data.select { |r| r["slug"].to_s == presenter["slug"].to_s }
    staff.first
  end

  def find_matching_user(presenter, data)
    # Find a user by matching on the name, unsure of a better way to do this
    users = data.select { |r| r["name"].to_s.downcase == presenter["name"].to_s.downcase }
    users.first
  end

  def find_matching_event_sponsorships(event, data)
    data.select { |r| r["event_id"].to_i == event["id"].to_i }
  end

  def find_unique_encoding_formats(data)
    formats = data.map do |video|
      video["encoding_format"].to_s
    end
    formats.uniq
  end

  desc "Find unique Blueprint classes"
  task :find_blueprint_classes => :environment do
    backup_root = "/Users/josephinehall/Development/wheeler-centre"
    backup_file = "#{backup_root}/backup-2014-12-18.yml"
    legacy_classes = open(backup_file).grep(/^---.*$/)
    class_names = legacy_classes.map do |class_name|
      class_name.split(":").last
    end
    puts(class_names.uniq)
  end

  desc "Find events with sponsors but without belonging to an event series"
  task :find_events_with_sponsors_sans_series, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])

    blueprint_records = YAML.load_stream(backup_data)

    blueprint_events = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtEvent}
    blueprint_sponsorships = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtSponsorship }
    puts (blueprint_events.count)

    events_sans_series = blueprint_events.select { |r| r["program_id"] == nil }
    puts (events_sans_series.count)
    events_with_sponsors = blueprint_events.map { |r| r["id"] } & blueprint_sponsorships.map { |r| r["event_id"] }
    puts (events_with_sponsors.count)
    events_sans_series_with_sponsors = events_sans_series.select {|r| events_with_sponsors.include? r["id"] }
    puts(events_sans_series_with_sponsors.count)

  end

end