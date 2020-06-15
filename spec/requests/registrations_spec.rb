# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  subject(:make_request) do
    post "/auth", params: params, as: :json
  end

  describe "Email registration method" do
    context "valid params" do
      let (:params) { attributes_for(:user).slice(:email, :password, :password_confirmation) }

      before { make_request }

      it "returns status 200" do
        expect(response.content_type).to eq("application/vnd.api+json; charset=utf-8")
        expect(response).to have_http_status(:success)
      end
    end
  end
end
