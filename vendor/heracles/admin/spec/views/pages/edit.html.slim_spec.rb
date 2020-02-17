require "spec_helper"

describe "heracles/admin/pages/edit.html.slim", type: :view do
  include_context "admin_view"

  def render
    super template: "heracles/admin/pages/edit", layout: "layouts/heracles/admin/admin_form"
  end

  let(:page) { mock_model(Heracles::Page, page_type: "content_page").as_null_object }

  before do
    # Controller environment
    allow(view).to receive(:action_name).and_return "index"

    assign :page, page
    assign :insertions, []

    allow(view).to receive(:page_type_policy_scope) { [] }
  end

  context "user permitted to change the tempalate" do
    let(:policy) { double(change_template?: true).as_null_object }

    before do
      render
    end

    it "shows a template field" do
      expect(rendered).to have_field("template")
    end
  end

  context "user not permitted to change the template" do
    let(:policy) { double(change_template?: false).as_null_object }

    before do
      render
    end

    it "shows a template field" do
      expect(rendered).not_to have_field("template")
    end
  end
end
