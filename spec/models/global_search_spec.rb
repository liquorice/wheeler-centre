require 'rails_helper'

RSpec.describe GlobalSearch, type: :model do
  describe '#results' do
    subject { GlobalSearch.new }
    
    it 'method exists' do
      Heracles::Site.create!(title: 'Title', slug: 'wheeler-centre')
      expect(subject).to respond_to(:results)
    end
  end

  describe '#facet' do
    it 'method exists' do
      Heracles::Site.create!(title: 'Title', slug: 'wheeler-centre')
      expect(subject).to respond_to(:facet)
    end
  end
end
