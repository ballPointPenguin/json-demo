# frozen_string_literal: true

RSpec.shared_examples "jsonapi request" do |model|
  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  describe "GET#index" do
    subject(:make_request) do
      get "/#{model_name.route_key}", params: params, as: :json
    end

    describe "basic fetch index" do
      let (:params) { }
      let!(:record1) { create(name_sym) }
      let!(:record2) { create(name_sym) }
      let(:record_ids) { [record1, record2].map { |record| record[:id].to_s } }

      it "returns a jsonapi collection" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(2)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array(model_name.collection)

        expect(jsonapi_data.map { |record| record[:id] })
          .to match_array(record_ids)
      end
    end
  end

  describe "GET#show" do
    subject(:make_request) do
      get "/#{model_name.route_key}/#{record.id}", params: params, as: :json
    end

    describe "basic fetch record" do
      let (:params) { }
      let!(:record) { create(name_sym) }

      it "returns a jsonapi object" do
        make_request

        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data).to be_a(Hash)

        expect(jsonapi_data[:type]).to eq(model_name.collection)
        expect(jsonapi_data[:id]).to eq(record.id.to_s)
      end
    end
  end

  describe "POST#create" do
    subject(:make_request) do
      post "/#{model_name.route_key}", params: params, as: :json
    end

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
        expect(response).to have_http_status(:created)
      end
    end
  end
end
