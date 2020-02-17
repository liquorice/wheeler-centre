require "spec_helper"

describe "heracles/admin/api/redirects/show.json.jbuilder", type: :view do
  before do
    allow(view).to receive(:redirect).and_return mock_model(Heracles::Redirect)
  end

  subject(:json) do
    render
    JSON.parse(rendered)["redirect"]
  end

  it { should include("id") }
  it { should include("source_url") }
  it { should include("target_url") }
end
