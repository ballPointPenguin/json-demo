# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "user_registration #create" do
    subject(:make_request) do
      post "/auth", params: params
    end

    context "valid params" do
      let (:params) { attributes_for(:user).slice(:email, :password, :password_confirmation) }

      it "returns successfully" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:success)
      end

      it "does NOT return acceses headers" do
        make_request

        expect(response.headers["access-token"]).not_to be_present
        expect(response.headers["client"]).not_to be_present
        expect(response.headers["expiry"]).not_to be_present
        expect(response.headers["uid"]).not_to be_present
      end

      it "creates a new user" do
        expect { make_request }.to change { User.count }.by(1)
      end
    end

    context "invalid params" do
      let (:params) { {
        email: "invalid_email.com",
        password: "something",
        password_confirmation: "something"
      } }

      it "returns an error" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(jsonapi_errors).to be_present
        expect(jsonapi_errors.keys).to contain_exactly(:email, :full_messages)
      end

      it "does not create a new user" do
        expect { make_request }.not_to change { User.count }
      end
    end
  end

  describe "user_registration #destroy", :skip do
    subject(:make_request) do
      delete "/auth", params: params
    end
  end

  describe "user_registration PATCH#update", :skip do
    subject(:make_request) do
      patch "/auth", params: params
    end
  end
end
