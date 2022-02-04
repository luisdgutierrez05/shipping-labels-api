# # frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::ShipmentLabels::Requests", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/shipment_labels/requests/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/shipment_labels/requests/show"
      expect(response).to have_http_status(:success)
    end
  end
end
