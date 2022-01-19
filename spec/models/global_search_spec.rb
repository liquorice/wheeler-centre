require 'rails_helper'

RSpec.describe GlobalSearch, type: :model do
  describe '#results' do
    subject { GlobalSearch.new }

    xit 'method exists' do
      expect(subject).to respond_to(:results)
    end
  end

  describe '#facet' do
    xit 'method exists' do
      expect(subject).to respond_to(:facet)
    end
  end
end
