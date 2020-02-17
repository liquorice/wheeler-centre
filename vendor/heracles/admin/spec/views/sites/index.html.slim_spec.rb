require "spec_helper"

describe "heracles/admin/sites/index.html.slim", type: :view do
  helper Heracles::Admin::Engine.routes.url_helpers

  let(:policy) { double(new?: true, edit?: true) }
  let(:heracles_admin_current_user) { double("User") }
  let(:site) { mock_model(Heracles::Site, title: "Test Site", hostnames: %w(example.com)).as_null_object }

  before do
    allow(view).to receive(:heracles_admin_current_user).and_return heracles_admin_current_user
    allow(view).to receive(:policy).and_return policy
    allow(view).to receive(:available_sites).and_return [site]
    allow(view).to receive(:sites).and_return [site]

    render
  end

  it "shows the list of sites the user can administer" do
    expect(rendered).to have_selector "a", text: "Test Site"
  end

  context "superadmin" do
    it "shows an edit link for each site" do
      expect(rendered).to have_selector "a[href='#{edit_site_path(site)}']", text: "Edit"
    end

    it "shows a link to the new site page" do
      expect(rendered).to have_selector "a[href='#{new_site_path}']"
    end
  end

  context "ordinary user" do
    let(:policy) { double(new?: false, edit?: false) }

    it "doesn't show an edit link" do
      expect(rendered).not_to have_selector "a", text: "Edit"
    end

    it "doesn't show a link to the new site page" do
      expect(rendered).not_to have_selector "a[href='#{new_site_path}']"
    end
  end
end
