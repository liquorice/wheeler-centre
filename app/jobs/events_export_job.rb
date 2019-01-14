require "csv"

class EventsExportJob < Que::Job

  def run(site_id, to_email)
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%s")
    attachments = []

    # Events
    events = find_events(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-events.csv",
      title: "Events",
      headers: events.first.csv_headers,
      rows: events.map(&:to_csv)
    })

    # People
    people = find_people(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-people.csv",
      title: "People",
      headers: people.first.csv_headers,
      rows: people.map(&:to_csv)
    })

    # Venues
    venues = find_venues(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-venues.csv",
      title: "Venues",
      headers: venues.first.csv_headers,
      rows: venues.map(&:to_csv)
    })

    # Series
    event_series = find_event_series(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-event-series.csv",
      title: "Event series",
      headers: event_series.first.csv_headers,
      rows: event_series.map(&:to_csv)
    })

    # Sponsors
    sponsors = find_sponsors(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-sponsors.csv",
      title: "Sponsors",
      headers: sponsors.first.csv_headers,
      rows: sponsors.map(&:to_csv)
    })

    # Topics
    topics = find_topics(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-topics.csv",
      title: "Topics",
      headers: topics.first.csv_headers,
      rows: topics.map(&:to_csv)
    })

    EventsExportMailer.export(to_email, attachments).deliver_now
  end

  private

  def find_events(site_id)
    Heracles::Sites::WheelerCentre::Event
      .where(site_id: site_id)
      .order("fields_data->'start_date'->>'value' DESC NULLS LAST")
      .to_a
  end

  def find_people(site_id)
    Heracles::Sites::WheelerCentre::Person
      .where(site_id: site_id)
      .order("fields_data->'first_name'->>'value' ASC")
      .to_a
  end

  def find_venues(site_id)
    Heracles::Sites::WheelerCentre::Venue
      .where(site_id: site_id)
      .order("fields_data->'first_name'->>'value' ASC")
      .to_a
  end

  def find_event_series(site_id)
    Heracles::Sites::WheelerCentre::EventSeries
      .where(site_id: site_id)
      .order(:created_at)
      .to_a
  end

  def find_sponsors(site_id)
    Heracles::Sites::WheelerCentre::Sponsor
      .where(site_id: site_id)
      .order(:created_at)
      .to_a
  end

  def find_topics(site_id)
    Heracles::Sites::WheelerCentre::Topic
      .where(site_id: site_id)
      .order(:created_at)
      .to_a
  end

  def build_csv_file(output_context)
    output = CSV.generate do |csv|
      csv << [output_context[:title]]
      csv << output_context[:headers]
      output_context[:rows].each do |row|
        csv << row
      end
    end
    [
      output_context[:filename],
      tempfile(output),
    ]
  end

  def tempfile(contents)
    file = Tempfile.new(["export", ".csv"])
    file.write(contents)
    file.rewind
    file
  end
end
