# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  it_behaves_like "jsonapi DELETE#destroy auth", User
  it_behaves_like "jsonapi GET#show auth", User
  it_behaves_like "jsonapi PATCH#update auth", User, :name, "new name"

  describe "jsonapi GET#index auth" do
    let(:user) do
      user = create(:user, password: "secretstuff")
      user.confirm
      user
    end

    subject(:make_request) do
      get "/users", params: params, headers: @headers
    end

    context "signed in in user" do
      before  {
        @headers = sign_in(user)
      }

      describe "basic fetch index" do
        let (:params) { }
        let!(:user2) { create(:user) }
        let(:record_ids) { [user, user2].map { |u| u[:id].to_s } }

        it "returns a jsonapi collection" do
          make_request

          expect(response.content_type).to eq("application/vnd.api+json")
          expect(response).to have_http_status(:success)
          expect(jsonapi_data.size).to eql(2)

          expect(jsonapi_data.map { |record| record[:type] }.uniq)
            .to match_array("users")

          expect(jsonapi_data.map { |record| record[:id] })
            .to match_array(record_ids)
        end
      end
    end
  end

  describe "jsonapi POST#create auth" do
    subject(:make_request) do
      post "/users", params: params, as: :json, headers: @headers
    end

    context "signed in user" do
      before { @headers = sign_in_user }

      describe "basic create record" do
        let (:attrs)  { attributes_for(:user) }
        let (:related) { attributes_for_related(:user) }
        let (:params) do
          {
            "data": {
              "type": "users",
              "attributes": dasherize_hash(attrs),
              "relationships": related
            }
          }
        end

        it "creates a database record" do
          expect { make_request }.to change { User.count }.by(1)
          expect(response).to have_http_status(:created)
        end
      end
    end
  end
end
