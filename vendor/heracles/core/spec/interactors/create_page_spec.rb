require "spec_helper"

describe Heracles::CreatePage do
  let(:interactor_options) { {} }
  subject(:result) do
    options = {
      site: mock_model(Heracles::Site),
      page_class: "content_page",
      page_params: {title: "Foo", slug: "foo"}
    }.merge(interactor_options)

    described_class.call(options)
  end

  let(:page) { mock_model(Heracles::Page).as_null_object }

  before do
    allow(Heracles::Page).to receive(:new_for_site_and_page_type).and_return(page)

    allow(page).to receive(:save).and_return(true)
  end

  it "builds the page" do
    expect(result.page).to eq page
  end

  it "assigns the page params" do
    expect(page).to receive(:attributes=).with({title: "Foo", slug: "foo"})

    result
  end

  it "saves the page" do
    expect(page).to receive(:save)

    result
  end

  it "succeeds" do
    expect(result).to be_a_success
  end

  context "building default children" do
    let(:interactor_options) { {create_default_children: true} }

    it "builds default children" do
      allow(page).to receive(:default_children_config) do
        [{title: "Child 1", slug: "child_1", type: :content_page}]
      end
      child_page = mock_model(Heracles::Page).as_null_object

      expect(Heracles::Page).to receive(:new_for_site_and_page_type).ordered
      expect(Heracles::Page).to receive(:new_for_site_and_page_type).ordered.and_return child_page

      expect(child_page).to receive(:parent=).with(page)
      expect(child_page).to receive(:save)

      result
    end
  end

  context "invalid params" do
    before do
      allow(page).to receive(:save).and_return(false)
    end

    it "fails" do
      expect(result).to be_a_failure
    end
  end
end
