require "spec_helper"

class TestPublicPagesController < ActionController::Base
  self.view_paths = []
  append_view_path File.expand_path("../../fixtures", __FILE__)

  include Heracles::PublicPagesController
end

describe TestPublicPagesController do
  include RSpec::Rails::ControllerExampleGroup

  render_views

  let(:site) { double("Site") }
  let(:published_page) { double("Page", page_type: "content_page", template: nil).as_null_object }
  let(:previewed_page) { double("Page", page_type: "content_page", template: nil).as_null_object }

  before do
    allow(site).to receive_message_chain(:redirects, :find_by_source_url).and_return nil
    allow(site).to receive_message_chain(:pages, :published, :find_by_url!).and_return published_page
    allow(site).to receive_message_chain(:pages, :find_by_url!).and_return previewed_page
  end

  describe "#site" do
    it "loads the site from 'heracles.site' in the request environment" do
      request.env["heracles.site"] = site

      expect(subject.site).to eq site
    end

    it "raises a record not found error if the site is missing" do
      expect { subject.site }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#page" do
    before do
      request.env["heracles.site"] = site
    end

    context "rendering public pages" do
      it "finds the page by URL from the site's published pages" do
        published_pages = double("Site published pages")
        allow(site).to receive_message_chain(:pages, :published).and_return(published_pages)

        expect(published_pages).to receive(:find_by_url!).with("foo/bar")

        subject.params = {path: "foo/bar"}
        subject.page
      end

      it "returns the page" do
        expect(subject.page).to eq published_page
      end
    end

    context "previewing pages" do
      it "finds the page by URL from all of the sites pages (published or unpublished)" do
        all_pages = double("Site pages")
        allow(site).to receive(:pages).and_return(all_pages)

        expect(all_pages).to receive(:find_by_url!).with("foo/bar").and_return(previewed_page)

        subject.params = {preview: true, path: "foo/bar"}
        subject.page
      end

      it "return the page" do
        subject.params = {preview: true}
        expect(subject.page).to eq previewed_page
      end

      it "overwrites the page attributes with the attributes provided in the params" do
        page_params = {title: "Overwritten Title"}
        subject.params = {preview: true, page: page_params}

        expect(previewed_page).to receive(:attributes=).with(page_params)
        subject.page
      end
    end
  end

  describe "handling requests" do
    before do
      request.env["heracles.site"] = site

      # Route setup method from http://pivotallabs.com/adding-routes-for-tests-specs-with-rails-3/
      Rails.application.routes.draw do
        post "/some/page/__preview" => "test_public_pages#show"
        get "/some/page" => "test_public_pages#show"
      end
    end

    after do
      # Reload the app's own routes again after these tests
      Rails.application.reload_routes!
    end

    describe "page template lookups" do
      context "no specific page_type template present" do
        let(:published_page) { double("Page", page_type: "not_present_type", template: nil) }

        it "renders the 'show' template" do
          get :show
          expect(response.body.strip).to eq "Hello from show"
        end
      end

      context "page_type template present" do
        let(:published_page) { double("Page", page_type: "content_page", template: nil) }

        it "renders the page_type template" do
          get :show
          expect(response.body.strip).to eq "Hello from content_page"
        end
      end

      context "custom named page template present" do
        let(:published_page) { double("Page", page_type: "content_page", template: "custom") }

        it "renders the custom named page template" do
          get :show
          expect(response.body.strip).to eq "Hello from content_page/custom"
        end
      end

      context "custom named page template specified by template file missing" do
        let(:published_page) { double("Page", page_type: "content_page", template: "missing") }

        it "renders the page_type template" do
          get :show
          expect(response.body.strip).to eq "Hello from content_page"
        end
      end
    end

    describe "page previews" do
      context "site token present" do
        let(:site) { double("Site", preview_token: "abc") }

        it "renders the page if the token matches" do
          post :show, preview: true, site_preview_token: "abc"
          expect(response.body.strip).to eq "Hello from content_page"
        end

        it "raises a 'not found' error if the token doesn't match" do
          expect { post :show, preview: true, site_preview_token: "not_matching" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "site token absent" do
        it "raises a 'not found' error" do
          expect { post :show, preview: true }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "redirecting" do
      it "looks for a redirect matching the current URL" do
        site_redirects = double("Site redirects")
        allow(site).to receive(:redirects).and_return(site_redirects)

        expect(site_redirects).to receive(:find_by_source_url).with("/foo/bar")
        get :show, path: "foo/bar"
      end

      context "redirect is found" do
        let(:site_redirect) { double("Redirect") }

        before do
          allow(site).to receive_message_chain(:redirects, :find_by_source_url).and_return(site_redirect)
        end

        it "redirects to another path if the target URL is relative" do
          allow(site_redirect).to receive(:target_url) { "/bar/baz" }

          get :show
          expect(response).to redirect_to("/bar/baz")
        end

        it "redirects to another site altogether if the target URL is absolute" do
          allow(site_redirect).to receive(:target_url) { "http://icelab.com.au/" }

          get :show
          expect(response).to redirect_to("http://icelab.com.au/")
        end
      end

      it "doesn't redirect if no redirect is found" do
        allow(site).to receive_message_chain(:redirects, :find_by_source_url).and_return(nil)

        get :show
        expect(response).to render_template(:show)
      end
    end
  end
end
