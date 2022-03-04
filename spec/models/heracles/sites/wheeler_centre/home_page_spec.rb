require 'rails_helper'

RSpec.describe Heracles::Sites::WheelerCentre::HomePage, type: :model do
  let(:home_page) { build(:home_page) }

  describe '.config' do
    it 'has :fields => []' do
      expect(home_page.config).to include(:fields)
      
      expect(home_page.config[:fields]).to include(
        { name: :intro, type: :content },
        # Banners
        {name: :banners, label: "Home page banners", type: :associated_pages, page_type: :home_banner},
        # Hero/Di Gribble Argument feature
        {name: :hero_feature_title, type: :text, hint: "Defaults to 'Featured Notes'"},
        {name: :hero_feature_tags, type: :text, editor_type: :code, hint: "Defaults to 'homepage-hero-feature'"},
        {name: :hero_feature_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
        {name: :display_hero_feature, type: :boolean, question_text: "Display the hero feature?", hint: "Even if checked, this will only be displayed if there is content available matching the tag(s) above"},
        # Highlights
        {name: :highlights_info, type: :info, text: "<hr/>"},
        {name: :highlights_primary_title, type: :text, editor_columns: 6},
        {name: :highlights_primary_tags, type: :text, editor_type: :code, editor_columns: 6, hint: "Defaults to 'highlights'"},
        {name: :highlights_primary_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
        {name: :display_highlights, type: :boolean, question_text: "Display highlights?", hint: "Even if checked, this will only be displayed if there is content available matching the tag(s) above"},
        # Quotes
        {name: :quotes_info, type: :info, text: "<hr/>"},
        {name: :quotes_title, type: :text},
        {name: :quotes_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
        {name: :quotes, label: "Home page quotes", type: :associated_pages, page_type: :home_quote},
        {name: :display_quotes, type: :boolean, question_text: "Display quotes?", hint: "Even if checked, this will only be displayed if there are quotes selected above"},
        # Writings
        {name: :writings_info, type: :info, text: "<hr/>"},
        {name: :writings_title, type: :text, editor_columns: 6},
        {name: :writings_tags, type: :text, editor_type: :code, editor_columns: 6, hint: "Separate multiple tags with a comma"},
        {name: :writings_content, type: :content, with_buttons: %i(bold italic), disable_insertables: true},
        {name: :display_writings, type: :boolean, question_text: "Display writings?", hint: "Even if checked, this will only be displayed if there is content available matching the tag(s) above"},
        # Body
        {name: :body_info, type: :info, text: "<hr/>"},
        {name: :body, type: :content},
        # About blurb
        {name: :about_info, type: :info, text: "<hr/>"},
        {name: :about_blurb, label: "About blurb", type: :content}
      )    
    end
  end

  describe '#sorted_banners' do
    xit 'with banners field' do
      
    end

    it 'without banners field' do      
      expect(home_page.sorted_banners).to be nil
    end     
  end

  describe '#highlights' do
    xit 'without options' do
      
    end

    xit 'with options' do

    end
  end

  describe '#user_writings' do
    xit '' do

    end
  end

  describe '#display_hero_feature?' do
    it 'returns false if no display_hero_feature' do      
      expect(home_page.fields[:display_hero_feature].data_present?).to be false
    end

    xit 'returns true if display_hero_feature' do
      
    end
  end

  describe '#display_highlights?' do
  end

  describe '#display_quotes?' do
  end

  describe '#display_writings?' do
  end

  describe '#hero_feature_items' do
  end

end
