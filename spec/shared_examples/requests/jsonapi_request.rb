# frozen_string_literal: true

RSpec.shared_examples "jsonapi GET#index auth" do |model|
  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  subject(:make_request) do
    get "/#{model_name.route_key}", params: params, headers: @headers
  end

  context "signed in in user" do
    before { @headers = sign_in_user }

    describe "basic fetch index" do
      let (:params) { }
      let!(:record1) { create(name_sym) }
      let!(:record2) { create(name_sym) }
      let(:record_ids) { [record1, record2].map { |record| record[:id].to_s } }

      it "returns a jsonapi collection" do
        make_request

        expect(response.content_type).to start_with("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(2)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array(model_name.collection)

        expect(jsonapi_data.map { |record| record[:id] })
          .to match_array(record_ids)
      end
    end
  end
end

RSpec.shared_examples "jsonapi GET#show auth" do |model|
  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  subject(:make_request) do
    get "/#{model_name.route_key}/#{record.id}",
      params: params, headers: @headers
  end

  context "signed in user" do
    before { @headers = sign_in_user }

    describe "basic fetch record" do
      let (:params) { }
      let!(:record) { create(name_sym) }

      it "returns a jsonapi object" do
        make_request

        expect(response.content_type).to start_with("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data).to be_a(Hash)

        expect(jsonapi_data[:type]).to eq(model_name.collection)
        expect(jsonapi_data[:id]).to eq(record.id.to_s)
      end
    end
  end
end

RSpec.shared_examples "jsonapi POST#create auth" do |model|
  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  subject(:make_request) do
    post "/#{model_name.route_key}",
      params: params, headers: @headers, as: :json
  end

  context "signed in user" do
    before { @headers = sign_in_user }

    describe "basic create record" do
      let (:attrs)  { attributes_for(name_sym) }
      let (:related) { attributes_for_related(name_sym) }
      let (:params) do
        {
          "data": {
            "type": model_name.collection,
            "attributes": attrs,
            "relationships": related
          }
        }
      end

      it "creates a database record" do
        expect { make_request }.to change { model.count }.by(1)
        expect(response.content_type).to start_with("application/vnd.api+json")
        expect(response).to have_http_status(:created)
      end
    end
  end
end

RSpec.shared_examples "jsonapi PATCH#update auth" do
  |model, update_key, update_val|

  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  subject(:make_request) do
    patch "/#{model_name.route_key}/#{record.id}",
      params: params, headers: @headers, as: :json
  end

  context "signed in user" do
    before { @headers = sign_in_user }

    describe "update the title" do
      let (:record) { create(name_sym) }
      let (:update_attr) { { update_key => update_val } }

      let (:params) do
        {
          "data": {
            "id": record.id.to_s,
            "type": model_name.collection,
            "attributes": update_attr
          }
        }
      end


      it "updates the resource" do
        make_request

        expect(response).to have_http_status(:success)
        expect(response.content_type).to start_with("application/vnd.api+json")
        expect(record.reload[update_key]).to eq(update_val)
      end
    end
  end
end

RSpec.shared_examples "jsonapi DELETE#destroy auth" do |model|
  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  subject(:make_request) do
    delete "/#{model_name.route_key}/#{record.id}", as: :json, headers: @headers
  end

  context "signed in user" do
    before { @headers = sign_in_user }

    describe "basic destroy" do
      let!(:record) { create(name_sym) }

      it "destroys the resource" do
        expect { make_request }.to change { model.count }.by(-1)
        expect(response).to have_http_status(:no_content)
        expect { record.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

RSpec.shared_examples "unauthorized request" do
  it "returns a jsonapi unauthorized error" do
    expect(response.content_type).to start_with("application/vnd.api+json")
    expect(response).to have_http_status(:unauthorized)
    expect(jsonapi_data).not_to be_present
    expect(jsonapi_errors).to be_present
    expect(jsonapi_errors)
      .to eq(["You need to sign in or sign up before continuing."])
  end
end
