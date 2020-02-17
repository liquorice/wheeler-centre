require "spec_helper"

describe Heracles::Admin::PagePolicy, type: :policy do
  subject(:policy) { described_class.new(user, page) }

  let(:page) { double("Page", locked?: false) }

  context "for a superadmin" do
    let(:user) { double("User", heracles_superadmin?: true) }
    let(:page_params) { %i(form_fields_json hidden published slug template title) }

    it { should permit_action(:index) }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should permit_action(:change_template) }

    it { should permit_attributes(*page_params) }
  end

  context "for an ordinary user" do
    let(:user) { double("User", heracles_superadmin?: false) }
    let(:page_params) { %i(form_fields_json hidden published slug title) }

    it { should permit_action(:index) }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should_not permit_action(:change_template) }

    it { should permit_attributes(*page_params) }
  end

  context "unlocked pages" do
    let(:user) { double("User", heracles_superadmin?: false) }
    let(:page) { double("Page", locked?: false) }

    it { should permit_action(:destroy) }
    it { should permit_action(:change_page_type) }
  end

  context "locked pages" do
    let(:user) { double("User", heracles_superadmin?: false) }
    let(:page) { double("Page", locked?: true) }

    it { should_not permit_action(:destroy) }
    it { should_not permit_action(:change_page_type) }
  end
end

describe Heracles::Admin::PagePolicy::Scope, type: :policy do
  subject(:scope) { described_class.new(user, starting_scope).resolve }

  let(:starting_scope) { double("Scope") }

  context "for a superdmin" do
    let(:user) { double("User", heracles_superadmin?: true) }

    it "doesn't adjust the scope" do
      expect(scope).to eq starting_scope
    end
  end

  context "for an ordinary user" do
    let(:user) { double("User", heracles_superadmin?: false) }

    it "doesn't adjust the scope" do
      expect(scope).to eq starting_scope
    end
  end
end
