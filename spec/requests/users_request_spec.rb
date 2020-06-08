# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  it_behaves_like "jsonapi request", User

  let (:model) { User }
  let (:model_name) { model.model_name }
  let (:name_sym) { model_name.singular.to_sym }

  describe "PATCH#update" do
    subject(:make_request) do
      patch "/#{model_name.route_key}/#{record.id}", params: params, as: :json
    end

    describe "update the title" do
      let (:record) { create(name_sym) }

      let (:params) do
        {
          "data": {
            "id": record.id.to_s,
            "type": model_name.collection,
            "attributes": {
              name: "new name"
            }
          }
        }
      end


      it "updates the resource" do
        make_request

        expect(response).to have_http_status(:success)
        expect(record.reload.name).to eq("new name")
      end
    end
  end
end
