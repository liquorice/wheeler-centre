require "spec_helper"

describe Heracles::PublicSiteManager::SiteHostConstraint do
  include RSpec::Rails::RailsExampleGroup
  include ActionController::TestCase::Behavior

  context "with a subdomain of admin host" do
    let(:site) { Heracles::Site.create! title: "Site 1", slug: "site1", origin_hostnames: ["site1.unimelb.edu.au"] }
    subject(:constraint) { Heracles::PublicSiteManager::SiteHostConstraint.new(site) }

    context "on the Heracles admin host" do
      before do
        @previous_admin_host = Heracles.configuration.admin_host
        Heracles.configure do |config| config.admin_host = "heracles.dev" end
      end

      after do
        Heracles.configure do |config| config.admin_host = @previous_admin_host end
      end

      context "which matches a site slug" do
        before do
          request.host = "site1.heracles.dev"
        end

        it "finds the site and sticks it in the request environment" do
          expect(constraint.matches?(request)).to be_truthy
          expect(request.env["heracles.site"]).to eq(site)
        end
      end

      context "without a matching site" do
        before do
          request.host = "something.heracles.dev"
        end

        it "does not match and does not populate request environment" do
          expect(constraint.matches?(request)).to be_falsey
          expect(request.env["heracles.site"]).to be_blank
        end
      end
    end
  end

  context "with another host" do
    let(:site) { Heracles::Site.create! title: "Site 1", slug: "site1", origin_hostnames: ["site1.unimelb.edu.au"] }
    subject(:constraint) { Heracles::PublicSiteManager::SiteHostConstraint.new(site) }

    context "which matches a site hostname" do
      before do
        request.host = site.all_hostnames.first
      end

      it "finds the site and sticks it in the request environment" do
        expect(constraint.matches?(request)).to be_truthy
        expect(request.env["heracles.site"]).to eq(site)
      end
    end

    context "without a matching site" do
      before do
        request.host = "example.com"
      end

      it "does not match and does not populate request environment" do
        expect(constraint.matches?(request)).to be_falsey
        expect(request.env["heracles.site"]).to be_blank
      end
    end
  end
end
