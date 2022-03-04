require 'rails_helper'

RSpec.describe Heracles::Sites::WheelerCentre::Event, type: :model do
  describe '.config' do    

    it 'has :fields => []' do
      expect(Heracles::Sites::WheelerCentre::Event.config).to include(:fields)
      
      expect(Heracles::Sites::WheelerCentre::Event.config[:fields]).to include(
        { name: :short_title, type: :text, label: "Short title", hint: "(optional) Set this to override the title in listings" }
      )
    end
    
  end

  describe '#to_summary_hash' do
  end

  describe '#booking_url' do
  end

  describe '#summary_title' do
  end

  describe '#upcoming?' do
  end

  describe '#booked_out?' do
  end

  describe '#recordings' do
  end

  describe '#podcast_episodes' do
  end

  describe '#series' do
  end

  describe '#secondary_series' do
  end

  describe '#venue' do
  end

  describe '#presenters' do
  end

  describe '#related_events' do
  end

  describe '#promo_image' do
  end

  describe '#csv_headers' do
    subject { Heracles::Sites::WheelerCentre::Event.new }

    it 'returns CSV headers' do
      expect(subject.csv_headers).not_to be_empty
      expect(subject.csv_headers).to start_with("ID")
      expect(subject.csv_headers).to end_with("Created at")
      expect(subject.csv_headers).to include(
        "ID",
        "Title",
        "URL",
        "Short title",
        "Promo image",
        "Thumbnail image",
        "Body",
        "Start date",
        "End date",
        "Display date",
        "Venue",
        "Ticket prices",
        "Bookings open at",
        "External bookings",
        "Presenters",
        "Series",
        "Recordings",
        "Podcast episodes",
        "Ticketing stage",
        "Promo text",
        "Sponsors intro",
        "Sponsors",
        "Topics",
        "Flarum discussion ID",
        "Updated at",
        "Created at"
      )
    end    
  end

  describe '#to_csv' do
    subject { Heracles::Sites::WheelerCentre::Event.new }

    it 'returns CSV fields' do      
      expect(subject.to_csv).not_to be_empty
    end
  end

end
