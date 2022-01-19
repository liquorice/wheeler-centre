require 'rails_helper'

RSpec.describe BulkPublicationSearch, type: :model do
  describe 'attributes' do    
    subject { BulkPublicationSearch.new(tags: 'tag', site_id: 123)}
    
    it 'allows reading for :site_id' do
      expect(subject.site_id).to eq(123)
      expect(subject).to have_attributes(site_id: 123)
    end

    it 'allows reading for :tags' do
      expect(subject.tags).to eq(['tag'])
      expect(subject).to have_attributes(tags: ['tag'])
    end
  end

  describe '#results' do
    subject { BulkPublicationSearch.new(tags: 'tag', site_id: 123)}
    
    it 'method exists' do
      expect(subject).to respond_to(:results)
    end

    xit 'returns pages' do

    end
  end
end