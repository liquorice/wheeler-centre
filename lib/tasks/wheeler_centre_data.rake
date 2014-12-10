namespace :wheeler_centre do
  desc "Import blueprint events"
  task :import_blueprint_events => :environment do

    # require "yaml"
    require "blueprint_shims"
    require "blueprint_import/bluedown_formatter"

    backup_root = "/Users/josephinehall/Development/wheeler-centre"
    backup_file = "#{backup_root}/backup.yml"
    backup_data = File.read(backup_file)

    blueprint_records = Syck.load_stream(backup_data).instance_variable_get(:@documents)

    # blueprint_events = YAML.load(backup_data).select { |r| r.class == LegacyBlueprint::CenevtEvent}

    blueprint_events = blueprint_records.select { |r| r.class == "CenevtEvent"}

    heracles_events_index = Heracles::Page.where(url: "events").first!
    heracles_events_collection = heracles_events_index.children.of_type("collection").where(slug: "all-events").first!

    puts(blueprint_events)

    blueprint_events.each do |blueprint_event|
      puts (blueprint_event.class)
      puts (blueprint_event["attributes"])

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

      heracles_event.created_at = blueprint_event["created_on"]

      heracles_event.fields[:start_date].value = Time.zone.parse(blueprint_event["start_date"].to_s)
      heracles_event.fields[:end_date].value = Time.zone.parse(blueprint_event["end_date"].to_s)

      heracles_event.fields[:is_all_day].value = %w(1 yes true).include?(blueprint_event["whole_day"].to_s)

      heracles_event.fields[:body].value = LegacyBlueprint::BluedownFormatter.mark_up(blueprint_event["content"], subject: blueprint_event)

      heracles_event.save!
    end
  end
end