require "spec_helper"

describe Heracles::Redirect do
  describe "validation" do
    before do
      # Satisfy the strict validation when testing other attributes
      subject.site = mock_model(Heracles::Site)
    end

    describe "site" do
      it { should validate_presence_of(:site).strict }
    end

    describe "source_url" do
      it { should allow_value("/foo/bar").for(:source_url) }
      it { should allow_value("/").for(:source_url) }

      it { should_not allow_value("foo/bar").for(:source_url) }
      it { should_not allow_value(nil).for(:source_url) }
      it { should_not allow_value("").for(:source_url) }
    end

    describe "target_url" do
      it { should allow_value("/bar/baz").for(:target_url) }
      it { should allow_value("http://icelab.com.au").for(:target_url) }

      it { should_not allow_value("bar/baz").for(:target_url) }
      it { should_not allow_value(nil).for(:target_url) }
      it { should_not allow_value("").for(:target_url) }
    end
  end
end
