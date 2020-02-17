require "spec_helper"

describe Heracles::Admin::UserPolicy, type: :policy do
  subject(:policy) { described_class.new(user, user_record) }

  let(:user_record) { double("User record") }

  context "for a superadmin" do
    let(:user) { double("User", heracles_superadmin?: true) }

    it { should permit_action(:index) }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }

    it { should permit_attributes(:name, :email, :password, :password_confirmation, :heracles_superadmin, site_ids: []) }
  end

  context "for an ordinary user" do
    let(:user) { double("User", heracles_superadmin?: false) }

    it { should_not permit_action(:index) }
    it { should_not permit_action(:new) }
    it { should_not permit_action(:create) }
    it { should_not permit_action(:edit) }
    it { should_not permit_action(:update) }
    it { should_not permit_action(:destroy) }

    it { should_not permit_attributes }
  end
end

describe Heracles::Admin::UserPolicy::Scope, type: :policy do
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

    it "restricts the scope to none" do
      expect(starting_scope).to receive(:none)
      scope
    end
  end
end
