# require 'rails_helper'

RSpec.describe "Api::V1::ShipmentLabels::Files", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/shipment_labels/files/show"
      expect(response).to have_http_status(:success)
    end
  end
end
