namespace :wheeler_centre do

  desc "Import blueprint events"
  task :import_blueprint_events, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = YAML.load_stream(backup_data)

    blueprint_events = blueprint_records.select { |r| r.class == LegacyBlueprint::CenevtEvent}
    heracles_events_index = Heracles::Page.where(url: "events").first!
    heracles_events_collection = heracles_events_index.children.of_type("collection").where(slug: "all-events").first!

    puts(blueprint_events)

    blueprint_events.each do |blueprint_event|
      # Find an existing event
      heracles_event = heracles_events_index.children.of_type("event").find_by_slug(blueprint_event["slug"])

      # Or build a new one
      unless heracles_event
        heracles_event = Heracles::Page.new_for_site_and_page_type(heracles_events_index.site, "event")
        heracles_event.parent = heracles_events_index
        heracles_event.collection = heracles_events_collection
      end

      heracles_event.published = true
      heracles_event.title = blueprint_event["title"]
      heracles_event.slug = blueprint_event["slug"]
      heracles_event.fields[:publish_at].value = Time.zone.parse(blueprint_event["publish_on"].to_s)
      heracles_event.created_at = Time.zone.parse(blueprint_event["created_on"].to_s)

      heracles_event.fields[:short_title].value = blueprint_event["short_title"].to_s
      heracles_event.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_event["content"], subject: blueprint_event, assetify: false)

      heracles_event.fields[:start_date].value = Time.zone.parse(blueprint_event["start_date"].to_s)
      heracles_event.fields[:end_date].value = Time.zone.parse(blueprint_event["end_date"].to_s)
      heracles_event.fields[:is_all_day].value = %w(1 yes true).include?(blueprint_event["whole_day"].to_s)

      heracles_event.fields[:venue].value = blueprint_event["venue"].to_s

      heracles_event.fields[:external_bookings].value = blueprint_event["booking_service_url"].to_s
      heracles_event.fields[:bookings_open_at].value = Time.zone.parse(blueprint_event["public_bookings_open_at"].to_s)

      heracles_event.save!
    end
  end

  desc "Import blueprint types that map to Page"
  task :import_blueprint_types_to_page, [:yml_file] => :environment do |task, args|
    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_data = File.read(args[:yml_file])
    blueprint_records = YAML.load_stream(backup_data)

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

      heracles_page = Heracles::Page.find_by_slug(slug)

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
    blueprint_records = YAML.load_stream(backup_data)
    parent = Heracles::Page.find_by_slug(args[:page_slug])
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
    blueprint_records = YAML.load_stream(backup_data)
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

        heracles_page = Heracles::Page.find_by_slug(slug)

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

        # Find all the Tum{#types} that have the id as their page_id, and sort them intore collections
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

end