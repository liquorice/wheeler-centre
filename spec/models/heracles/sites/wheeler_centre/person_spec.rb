require 'rails_helper'

RSpec.describe Heracles::Sites::WheelerCentre::Person, type: :model do
  let (:person) { build(:person) }

  describe ".config" do

    it 'has :fields => []' do
      expect(person.config).to include(:fields)
      
      expect(person.config[:fields]).to include(
        {name: :first_name, type: :text},
        {name: :last_name, type: :text},
        {name: :portrait, type: :assets, assets_file_type: :image},
        {name: :intro, type: :content},
        {name: :biography, type: :content},
        {name: :url, type: :text},
        {name: :twitter_name, type: :text},
        {name: :reviews, type: :content},
        {name: :external_links, type: :content},
        {name: :is_staff_member, type: :boolean, defaults: {value: false}, question_text: "Is a Wheeler Centre staff member?"},
        {name: :staff_bio, type: :content, label: "Staff biography", display_if: 'is_staff_member.value'},
        {name: :position_title, type: :text, display_if: 'is_staff_member.value'},
        {name: :legacy_user_id, type: :integer, label: "Legacy User ID"},
        {name: :legacy_presenter_id, type: :integer, label: "Legacy Presenter ID"},
        {name: :topics, type: :associated_pages, page_type: :topic}
      )
    end
  end
end
