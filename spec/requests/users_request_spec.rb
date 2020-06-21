# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:confirmed_user) }
  let(:admin) { create(:admin) }
  let (:params) { }

  let (:create_params) do
    attrs = attributes_for(:user)
    related = attributes_for_related(:user)

    {
      "data": {
        "type": "users",
        "attributes": dasherize_hash(attrs),
        "relationships": related
      }
    }
  end

  it_behaves_like "jsonapi DELETE#destroy auth", User
  it_behaves_like "jsonapi GET#show auth", User
  it_behaves_like "jsonapi PATCH#update auth", User, :name, "new name"

  subject(:make_index_request) do
    get "/users", params: params, headers: @headers
  end

  subject(:make_create_request) do
    post "/users", params: params, as: :json, headers: @headers
  end

  context "not signed in" do
    describe "jsonapi GET#index" do
      before { make_index_request }
      it_behaves_like "unauthorized request"
    end

    describe "jsonapi POST#create" do
      let (:attrs)  { attributes_for(:user) }
      let (:related) { attributes_for_related(:user) }
      let (:params) { create_params }

      before { make_create_request }
      it_behaves_like "unauthorized request"
    end
  end

  context "signed in user" do
    before { sign_in(user) }

    describe "jsonapi GET#index" do
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }

      it "returns a jsonapi collection of only the user" do
        make_index_request

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(1)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array("users")

        expect(jsonapi_data.map { |record| record[:id] })
          .to eq([user.id.to_s])
      end
    end
  end

  context "signed in admin" do
    before { sign_in(admin) }

    describe "jsonapi GET#index" do
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let(:record_ids) { [admin, user2, user3].map { |u| u[:id].to_s } }

      it "returns a jsonapi collection of all users" do
        make_index_request

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(3)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array("users")

        expect(jsonapi_data.map { |record| record[:id] })
          .to match_array(record_ids)
      end
    end

    describe "jsonapi POST#create" do
      let(:params) { create_params }

      it "creates a database record" do
        expect { make_create_request }.to change { User.count }.by(1)
        expect(response).to have_http_status(:created)
      end
    end
  end
end
