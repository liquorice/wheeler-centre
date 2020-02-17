require "spec_helper"

describe Heracles::Admin::Api::RedirectsController, type: :controller do
  routes { Heracles::Admin::Engine.routes }

  let(:site) { double("Site").as_null_object }

  before do
    allow(subject).to receive(:heracles_admin_current_user).and_return double("User", heracles_admin?: true)
    allow(subject).to receive(:site).and_return site
  end

  describe "exposures" do
    before do
      subject.params = {site_id: "site-slug"}
    end

    describe "#redirects" do
      it "finds the redirects from the site" do
        site_redirects = double("Site redirects")
        expect(site).to receive_message_chain(:redirects, :all).and_return site_redirects

        subject.redirects
      end
    end

    describe "#redirect" do
      context "POST or PATCH requests" do
        let(:redirect) { double("Redirect").as_null_object }
        # TODO: extract into a `valid_params` method
        let(:redirect_params) { {"source_url" => "/foo", "target_url" => "/bar"} }

        before do
          subject.request = double("Request", get?: false, delete?: false)
          subject.params[:redirect] = redirect_params

          allow(site).to receive_message_chain(:redirects, :all, :new).and_return redirect
        end

        context "ID in params" do
          before do
            subject.params[:id] = "abc"
          end

          it "finds the redirect from the site" do
            site_redirects = double("Site redirects")
            allow(site).to receive_message_chain(:redirects, :all).and_return site_redirects

            expect(site_redirects).to receive(:find).with("abc").and_return redirect
            subject.redirect
          end
        end

        context "no ID in params" do
          it "builds a redirect from the site" do
            expect(site).to receive_message_chain(:redirects, :all, :new).and_return redirect
            subject.redirect
          end
        end

        it "assigns redirect attributes" do
          expect(redirect).to receive(:attributes=).with redirect_params
          subject.redirect
        end
      end
    end
  end

  # TODO: This is failing. Fix or build some kind of spec to test this kind of thing.
  # describe "parameter wrapping" do
  #   before do
  #     request.env["CONTENT_TYPE"] = "application/json"
  #   end
  #
  #   it "wraps redirect parameters" do
  #     post :create, format: "json", site_id: "abc", source_url: "/foo", target_url: "/bar", redirect_order_position: "1"
  #
  #     expect(request.params[:redirect][:source_url]).to eq "/foo"
  #     expect(request.params[:redirect][:target_url]).to eq "/bar"
  #     expect(request.params[:redirect][:redirect_order_position]).to eq "1"
  #   end
  # end

  describe "actions" do
    let(:redirect) { mock_model(Heracles::Redirect) }

    before do
      allow(controller).to receive(:redirect).and_return redirect
    end

    describe "POST create" do
      it "saves the redirect" do
        expect(redirect).to receive(:save)
        post :create, format: :json, site_id: "abc"
      end
    end

    describe "PATCH update" do
      it "saves the redirect" do
        expect(redirect).to receive(:save)
        patch :update, format: :json, site_id: "abc", id: "abc"
      end
    end

    describe "DELETE destroy" do
      it "deletes the redirect" do
        expect(redirect).to receive(:destroy)
        delete :destroy, format: :json, site_id: "abc", id: "abc"
      end
    end
  end
end
