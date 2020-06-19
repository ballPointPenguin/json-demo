# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "user_session #create" do
    subject(:make_request) do
      post "/auth/sign_in", params: params
    end

    let(:user) do
      user = create(:user, password: "secretstuff")
      user.confirm
      user
    end

    context "valid params" do
      let (:params) { { email: user.email, password: "secretstuff" } }

      it "returns successfully" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:success)
      end

      it "retruns the right headers" do
        make_request

        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response.headers["expiry"]).to be_present
        expect(response.headers["uid"]).to be_present
      end

      it "creates a new user" do
        expect { make_request }.to change { User.count }.by(1)
      end
    end

    context "invalid password" do
      let (:params) { {
        email: user.email,
        password: "something"
      } }

      it "returns an error" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:unauthorized)
        expect(jsonapi_errors).to eq(["Invalid login credentials. Please try again."])
      end
    end

    context "non-existent user" do
      let (:params) { {
        email: "nobody@example.foo",
        password: "something"
      } }

      it "returns an error" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:unauthorized)
        expect(jsonapi_errors).to eq(["Invalid login credentials. Please try again."])
      end
    end
  end

  # describe "user_session #destroy", :skip do
  #   subject(:make_request) do
  #     delete "/auth/sign_out", params: params
  #   end
  # end

  # describe "user_session PATCH#update", :skip do
  #   subject(:make_request) do
  #     get "/auth/sign_in", params: params
  #   end
  # end
end
