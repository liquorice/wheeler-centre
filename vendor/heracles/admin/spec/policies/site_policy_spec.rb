require "spec_helper"

describe Heracles::Admin::SitePolicy, type: :policy do
  subject(:policy) { described_class.new(user, site) }

  let(:site) { double("Site") }

  context "for a superadmin" do
    let(:user) { double("User", heracles_superadmin?: true) }

    it { should permit_action(:index) }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context "for an ordinary user" do
    let(:user) { double("User", heracles_superadmin?: false) }

    it { should permit_action(:index) }

    it { should_not permit_action(:new) }
    it { should_not permit_action(:create) }
    it { should_not permit_action(:edit) }
    it { should_not permit_action(:update) }
    it { should_not permit_action(:destroy) }
  end
end
