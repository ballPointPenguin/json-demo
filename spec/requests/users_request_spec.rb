# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:collection) { model_name.collection } # "users"
  let(:model) { User } # [User]
  let(:model_name) { model.model_name } # [ModelName]
  let(:name_sym) { model_name.singular.to_sym } # :user
  let(:route_key) { model_name.route_key } # "users"

  let(:params) { }
  let(:admin) { create(:admin) }
  let(:record) { create(:user) }
  let(:user) { create(:confirmed_user) }

  let(:create_params) do
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

  let(:update_params) do
    {
      "data": {
        "id": record.id.to_s,
        "type": collection,
        "attributes": { "name": "New Name" }
      }
    }
  end

  subject(:make_index_request) do
    get "/#{route_key}", params: params, headers: @headers
  end

  subject(:make_show_request) do
    get "/#{route_key}/#{record.id}", params: params, headers: @headers
  end

  subject(:make_create_request) do
    post "/#{route_key}", params: params, headers: @headers, as: :json
  end

  subject(:make_update_request) do
    patch "/#{route_key}/#{record.id}",
      params: update_params, headers: @headers, as: :json
  end

  subject(:make_destroy_request) do
    delete "/#{route_key}/#{record.id}", headers: @headers
  end

  it_behaves_like "jsonapi DELETE#destroy auth", User
  # it_behaves_like "jsonapi GET#show auth", User
  it_behaves_like "jsonapi PATCH#update auth", User, :name, "new name"

  context "not signed in" do
    describe "GET#index" do
      before { make_index_request }
      it_behaves_like "unauthorized request"
    end

    describe "GET#show" do
      before { make_show_request }

      it_behaves_like "unauthorized request"
    end

    describe "POST#create" do
      let(:attrs)  { attributes_for(:user) }
      let(:related) { attributes_for_related(:user) }
      let(:params) { create_params }

      before { make_create_request }

      it_behaves_like "unauthorized request"
    end

    describe "PATCH#update" do
      let(:params) { { name: "New Name" } }

      before { make_update_request }

      it_behaves_like "unauthorized request"
    end

    describe "DELETE#destroy" do
      before { make_destroy_request }

      it_behaves_like "unauthorized request"
    end
  end

  context "signed in user" do
    before { sign_in(user) }

    describe "GET#index" do
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }

      it "returns a jsonapi collection of only the user" do
        make_index_request

        expect(response.content_type).to start_with("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(1)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array("users")

        expect(jsonapi_data.map { |record| record[:id] })
          .to eq([user.id.to_s])
      end
    end

    describe "GET#show own user" do
      let(:record) { user }

      before { make_show_request }

      it_behaves_like "successful request"

      it "returns the user's record" do
        expect(jsonapi_data).to be_a(Hash)
        expect(jsonapi_data[:type]).to eq(collection)
        expect(jsonapi_data[:id]).to eq(record.id.to_s)
      end
    end

    describe "GET#show other user" do
      let(:record) { create(:user) }

      before { make_show_request }

      it_behaves_like "forbidden request"
    end
  end

  context "signed in admin" do
    before { sign_in(admin) }

    describe "GET#index" do
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let(:record_ids) { [admin, user2, user3].map { |u| u[:id].to_s } }

      it "returns a jsonapi collection of all users" do
        make_index_request

        expect(response.content_type).to start_with("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(3)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array("users")

        expect(jsonapi_data.map { |record| record[:id] })
          .to match_array(record_ids)
      end
    end

    describe "GET#show own user" do
      let(:record) { user }

      before { make_show_request }

      it_behaves_like "successful request"

      it "returns the user's record" do
        expect(jsonapi_data).to be_a(Hash)
        expect(jsonapi_data[:type]).to eq(collection)
        expect(jsonapi_data[:id]).to eq(record.id.to_s)
      end
    end

    describe "GET#show other user" do
      let(:record) { create(:user) }

      before { make_show_request }

      it_behaves_like "successful request"

      it "returns the user's record" do
        expect(jsonapi_data).to be_a(Hash)
        expect(jsonapi_data[:type]).to eq(collection)
        expect(jsonapi_data[:id]).to eq(record.id.to_s)
      end
    end

    describe "POST#create" do
      let(:params) { create_params }

      it "creates a database record" do
        expect { make_create_request }.to change { User.count }.by(1)
        expect(response).to have_http_status(:created)
      end
    end
  end
end
