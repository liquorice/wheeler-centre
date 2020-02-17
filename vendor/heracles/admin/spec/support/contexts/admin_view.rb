shared_context "admin_view", type: :view do
  helper \
    Heracles::Admin::Engine.routes.url_helpers,
    Heracles::Admin::ApplicationHelper,
    Heracles::Admin::FormsHelper,
    Heracles::Admin::FlashesHelper

  let(:policy) { double() }
  let(:heracles_admin_current_user) { double("User").as_null_object }
  let(:site) { mock_model(Heracles::Site, engine_path: "foo/bar", page_classes: [], hostnames: []) }

  before do
    allow(view).to receive(:policy).and_return policy

    allow(view).to receive(:heracles_admin_current_user).and_return heracles_admin_current_user

    allow(view).to receive(:site).and_return site
    allow(view).to receive(:available_sites).and_return [site]

    allow(view).to receive(:heracles_admin_login_path).and_return "/"
    allow(view).to receive(:heracles_admin_logout_path).and_return "/"
  end
end
