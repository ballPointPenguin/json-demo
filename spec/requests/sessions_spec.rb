# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) do
    user = create(:user, password: "secretstuff")
    user.confirm
    user
  end

  describe "user_session #create" do
    subject(:make_request) do
      post "/auth/sign_in", params: params
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
        email: Faker::Internet.email,
        password: Faker::Internet.password
      } }

      it "returns an error" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:unauthorized)
        expect(jsonapi_errors).to eq(["Invalid login credentials. Please try again."])
      end
    end
  end

  describe "user_session #destroy" do
    subject(:make_request) do
      delete "/auth/sign_out", headers: @headers
    end

    before do
      post "/auth/sign_in", params: { email: user.email, password: user.password }

      @headers = {
        "access-token" => response.headers["access-token"],
        "client" => response.headers["client"],
        "uid" => response.headers["uid"]
      }
    end

    it "is successful" do
      make_request

      expect(response).to have_http_status(:success)
    end
  end
end
