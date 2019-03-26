require "csv"

class ContentExportJob < Que::Job

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

    # Blog posts (news)
    blog_posts = find_blog_posts(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-news.csv",
      title: "News",
      headers: blog_posts.first.csv_headers,
      rows: blog_posts.map(&:to_csv)
    })

    # Longform blog posts (notes)
    longform_blog_posts = find_longform_blog_posts(site_id)
    attachments << build_csv_file({
      filename: "#{timestamp}-notes.csv",
      title: "Notes",
      headers: longform_blog_posts.first.csv_headers,
      rows: longform_blog_posts.map(&:to_csv)
    })

    client = Aws::S3::Client.new(
      region: ENV["ASSETS_AWS_REGION"],
      access_key_id: ENV["ASSETS_AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["ASSETS_AWS_SECRET_ACCESS_KEY"]
    )

    export_id = SecureRandom.uuid
    bucket_name = ENV["ASSETS_AWS_BUCKET"]
    bucket = Aws::S3::Bucket.new(
      bucket_name,
      client: client
    )
    uploaded_attachments = attachments.map {|attachment|
      file, path = attachment
      key = "content-exports/#{export_id}/#{file}"
      bucket.put_object(
        acl: "public-read",
        body: path,
        key: key
      )
      public_url = bucket.object(key).public_url
      [file, public_url]
    }

    ContentExportMailer.export(to_email, uploaded_attachments).deliver_now
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

  def find_blog_posts(site_id)
    Heracles::Sites::WheelerCentre::BlogPost
      .where(site_id: site_id)
      .order(:created_at)
      .to_a
  end

  def find_longform_blog_posts(site_id)
    Heracles::Sites::WheelerCentre::LongformBlogPost
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
