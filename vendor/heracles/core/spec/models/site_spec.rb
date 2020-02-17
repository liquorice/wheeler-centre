require "spec_helper"

describe Heracles::Site do
  describe "validation" do
    %i(origin_hostnames edge_hostnames).each do |hostname_attr|
      describe "#{hostname_attr}" do
        it { should allow_value(%w{localhost}).for(hostname_attr) }
        it { should allow_value(%w{localhost:3000}).for(hostname_attr) }
        it { should allow_value(%w{site.unimelb.edu.au}).for(hostname_attr) }
        it { should allow_value(%w{site.unimelb.edu.au example.com}).for(hostname_attr) }
        it { should allow_value(%w{127.0.0.1}).for(hostname_attr) }

        it { should_not allow_value(%w{badname}).for(hostname_attr) }
        it { should_not allow_value(%w{localhost:}).for(hostname_attr) }
        it { should_not allow_value(%w{example.com badname}).for(hostname_attr) }
        it { should_not allow_value(%w{http://example.com/}).for(hostname_attr) }
      end
    end
  end

  describe "custom finder methods" do
    let!(:site) { create(:site, origin_hostnames: %w{test.com another.com}) }

    describe ".find_by_hostname" do
      specify { expect(described_class.find_by_hostname("test.com")).to eq site }
      specify { expect(described_class.find_by_hostname("missing.com")).to be_nil }
    end

    describe ".find_by_hostname!" do
      specify { expect(described_class.find_by_hostname!("test.com")).to eq site }
      specify { expect { described_class.find_by_hostname!("missing.com") }.to raise_error }
    end

    describe ".servable" do
      module Heracles::Sites::TestSite
        class Engine
        end
      end

      let!(:site) { create(:site, slug: "test-site") }
      let!(:non_servable_site) { create(:site, slug: "engine-not-present") }

      specify { expect(described_class.servable).to include site }
      specify { expect(described_class.servable).to_not include non_servable_site }
    end
  end

  describe "custom first/last scopes" do
    let!(:last_site)  { create(:site, created_at: 3.months.ago) }
    let!(:first_site) { create(:site, created_at: 5.months.ago) }

    specify { expect(described_class.first).to eq first_site }
    specify { expect(described_class.last).to eq last_site }
  end

  describe "callbacks" do
    subject(:site) { described_class.new }

    it "runs #set_preview_token before create" do
      expect(site).to receive(:set_preview_token)
      site.run_callbacks(:create) { false }
    end

    describe "#set_preview_token" do
      it "populates the preview token field" do
        expect { site.send :set_preview_token }.to change { site.preview_token }.from(nil).to(String)
      end
    end
  end
end
