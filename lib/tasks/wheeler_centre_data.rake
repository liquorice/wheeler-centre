namespace :wheeler_centre do
  desc "Import blueprint events"
  task :import_blueprint_events => :environment do

    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_root = "/Users/josephinehall/Development/wheeler-centre"
    backup_file = "#{backup_root}/backup.yml"
    backup_data = File.read(backup_file)
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
      heracles_event.fields[:member_bookings_open_at].value = Time.zone.parse(blueprint_event["member_bookings_open_at"].to_s)

      heracles_event.save!
    end
  end

  desc "Import blueprint pages"
  task :import_blueprint_pages => :environment do

    require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_root = "/Users/josephinehall/Development/wheeler-centre"
    backup_file = "#{backup_root}/backup.yml"
    backup_data = File.read(backup_file)
    blueprint_records = YAML.load_stream(backup_data)

    blueprint_pages = blueprint_records.select { |r| r.class == LegacyBlueprint::Page}

    parent = Heracles::Page.where(url: "home").first!

    # Todo: figure out how to strucure the pages within the site
    blueprint_pages.each do |blueprint_page|

      # If a parent page is set in the yaml, find it and use it as the Heracles parent
      if blueprint_page["parent_page"].present?
        parent = Heracles::Page.find_by_slug(blueprint_page["parent_page"])
      end

      heracles_page = Heracles::Page.find_by_slug(blueprint_page["slug"])

      unless heracles_page
        heracles_page = Heracles::Page.new_for_site_and_page_type(homepage.site, "content_page")
        heracles_page.parent = parent
      end

      heracles_page.published = true
      heracles_page.slug = blueprint_page["slug"]
      heracles_page.title = blueprint_page["title"]
      heracles_page.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_page["content"], subject: blueprint_page, assetify: false)
      heracles_page.fields[:short_title].value = blueprint_page["short_title"]

      heracles_page.save!
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