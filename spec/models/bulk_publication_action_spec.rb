require 'rails_helper'
require 'securerandom'

RSpec.describe BulkPublicationAction, :type => :model do
  describe 'Validations' do   
    it 'passes for :site_id' do
      expect validate_presence_of(:site_id)
    end
    it 'passes for :user_id' do
      expect validate_presence_of(:user_id)
    end
    it 'passes for :tags' do
      expect validate_presence_of(:tags)
    end
    it 'passes for :action' do
      expect validate_presence_of(:action)
    end
  end

  describe 'Scope' do
    it 'in_progress works' do
      expect(described_class.in_progress(SecureRandom.uuid,1)).to eq([])
    end
  end

  describe '#readable_tags' do
    subject {BulkPublicationAction.new(site_id: 1, user_id: 1, tags: 'tag', action: 1)}
    it 'converts to html' do
      expect(subject.readable_tags).to eq("<i>tag</i>")
    end
  end
end