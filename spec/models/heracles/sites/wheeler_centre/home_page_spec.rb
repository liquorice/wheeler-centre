require 'rails_helper'

RSpec.describe Heracles::Sites::WheelerCentre::HomePage, type: :model do
  describe '.config' do
    it 'has :fields => []' do
      expect(Heracles::Sites::WheelerCentre::HomePage.config).to include(:fields)
      
      expect(Heracles::Sites::WheelerCentre::HomePage.config[:fields]).to include(
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
    it 'with banners field' do

      homepage = Heracles::Sites::WheelerCentre::HomePage.new
      dbl = double(homepage)
      allow(dbl).to receive(:sorted_banners).and_return("banners")
      expect(dbl.sorted_banners).to eq("banners")
      
    end

    it 'without banners field' do
      homepage = Heracles::Sites::WheelerCentre::HomePage.new
      expect(homepage.sorted_banners).to be nil
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
      expect(subject.fields[:display_hero_feature].data_present?).to be false
    end

    xit 'returns true if display_hero_feature' do
      expect(subject.fields[:display_hero_feature].data_present?).to be true
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
