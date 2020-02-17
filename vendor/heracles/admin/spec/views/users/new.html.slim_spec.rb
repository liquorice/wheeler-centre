# TODO: replace or re-enable once we provide a user/auth engine
# require "spec_helper"
#
# describe "heracles/admin/users/new.html.slim", type: :view do
#   include_context "admin_view"
#
#   let(:user) { double("User").as_null_object }
#   let(:site) { mock_model(Heracles::Site, id: 1, title: "Test Site") }
#
#   before do
#     allow(view).to receive(:user).and_return user
#     allow(view).to receive(:sites).and_return [site]
#
#     render
#   end
#
#   it "shows the sites as checkboxes" do
#     expect(rendered).to have_selector "input[type='checkbox'][name='user[site_ids][]']", count: 1
#     expect(rendered).to have_selector "input[type='checkbox'][name='user[site_ids][]'][value='1']"
#   end
# end
