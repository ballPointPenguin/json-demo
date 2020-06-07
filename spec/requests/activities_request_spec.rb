# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Activities", type: :request do
  describe "activities#index" do
    let(:params) { }

    subject(:make_request) do
      headers = { "ACCEPT" => "application/vnd.api+json" }
      get "/activities", headers: headers, params: params
    end

    describe "basic fetch" do
      let!(:activity1) { create(:activity) }
      let!(:activity2) { create(:activity) }

      it "works" do
        make_request

        assert_equal 2, jsonapi_data.size
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(response).to have_http_status(:success)
        expect(jsonapi_data.size).to eql(2)

        expect(jsonapi_data.map { |record| record[:type] }.uniq)
          .to match_array(["activities"])

        expect(jsonapi_data.map { |record| record[:id].to_i })
          .to match_array([activity1.id, activity2.id])
      end
    end
  end
end
