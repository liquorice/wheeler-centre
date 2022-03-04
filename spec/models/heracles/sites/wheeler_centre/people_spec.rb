require 'rails_helper'

RSpec.describe Heracles::Sites::WheelerCentre::People, type: :model do
  let! (:people) { create(:people) }
  let! (:person) { create(:person, site: people.site, parent: people ) }

  describe 'site' do
    it 'has the site' do
      expect(people.site_id).not_to be_empty
    end
  end

  describe ".config" do
    it 'has :fields => []' do
      expect(people.config).to include(:fields)
      
      expect(people.config[:fields]).to include(
        {name: :intro, type: :content},
        {name: :body, type: :content},
        # Coming up intro
        {name: :coming_up_info, type: :info, text: "<hr/>"},
        {name: :coming_up_intro, type: :content}
      )
    end
  end

  describe '#people' do
    it 'returns person from database' do            
      expect(people.people).not_to be_empty
    end
  end

  describe '#people_from_upcoming_events' do

  end

end
