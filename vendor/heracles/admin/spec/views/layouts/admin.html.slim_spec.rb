require "spec_helper"

describe "layouts/heracles/admin/admin.html.slim", type: :view do
  # TODO: would be nice if these could come in automatically
  helper \
    Heracles::Admin::Engine.routes.url_helpers,
    Heracles::Admin::ApplicationHelper,
    Heracles::Admin::FlashesHelper

  let(:heracles_admin_current_user) { double("User", heracles_admin_name: "Test User").as_null_object }
  let(:site) { mock_model(Heracles::Site, title: "Test Site", hostnames: %w(example.com)).as_null_object }

  before do
    # Controller environment
    allow(view).to receive(:action_name).and_return "index"

    # User login
    allow(view).to receive(:heracles_admin_current_user).and_return heracles_admin_current_user

    # Exposures
    allow(view).to receive(:site).and_return nil
    allow(view).to receive(:available_sites).and_return [site]
  end

  context "within a site" do
    let(:site) { mock_model(Heracles::Site, title: "Best Site").as_null_object }

    before do
      allow(view).to receive(:site).and_return site
      allow(view).to receive(:available_sites).and_return [site, site]


      render text: "", layout: "layouts/heracles/admin/admin"
    end

    it "shows the site's name in the nav" do
      expect(rendered).to have_selector "a[href='#{site_pages_path(site)}']", text: "Best Site"
    end

    it "shows the other available sites in a nav dropdown" do
      expect(rendered).to have_selector "a[href='#{site_pages_path(site)}']", text: "Test Site"
    end
  end

  context "for all users" do
    let(:heracles_admin_current_user) { double("User", heracles_admin_name: "Test User", heracles_superadmin?: false) }

    before do
      render text: "", layout: "layouts/heracles/admin/admin"
    end

    it "shows a link to the sites section (the main admin page)" do
      expect(rendered).to have_selector "a[href='#{sites_path}']", text: "Sites"
    end

    it "shows a sign out link" do
      expect(rendered).to have_selector "a[href='/']", text: "Sign out"
    end

    it "shows the current user's name" do
      expect(rendered).to match "Test User"
    end

    it "shows a link to the edit account page"
  end

  context "for superadmins" do
    let(:heracles_admin_current_user) { double("User", heracles_admin_name: "Test User", heracles_superadmin?: true) }

    before do
      render text: "", layout: "layouts/heracles/admin/admin"
    end

    # TODO: re-enable some kind of test like this when we provide a users/auth engine
    # it "shows a link to the users section" do
    #   expect(rendered).to have_selector "a[href='#{users_path}']", text: "Users"
    # end
  end

  context "for ordinary users" do
    let(:heracles_admin_current_user) { double("User", heracles_admin_name: "Test User", heracles_superadmin?: false) }

    before do
      render text: "", layout: "layouts/heracles/admin/admin"
    end

    it "does not show a link to the users section" do
      expect(rendered).not_to have_selector "a[href='#{users_path}']"
    end
  end
end
