# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::ShipmentLabels::Requests', type: :request do
  describe 'GET /create' do
    let(:body_params) do
      {
        "data": {
          "shipment_labels": [
            {
              "carrier": "fake_carrier",
              "shipment": {
                "address_from": {
                  "name": "Fernando López",
                  "street1": "Av. Principal #123",
                  "city": "Azcapotzalco",
                  "province": "Ciudad de México",
                  "postal_code": "02900",
                  "country_code": "MX"
                },
                "address_to": {
                  "name": "Isabel Arredondo",
                  "street1": "Av. Las Torres #123",
                  "city": "Puebla",
                  "province": "Puebla",
                  "postal_code": "72450",
                  "country_code": "MX"
                },
                "parcels": [
                  {
                    "length": 40,
                    "width": 40,
                    "height": 40,
                    "dimensions_unit": "CM",
                    "weight": 5,
                    "weight_unit": "KG"
                  }
                ]
              }
            }
          ]
        }
      }
    end

    let(:serializer) { Api::V1::ShipmentLabels::RequestSerializer }
    let(:shipment_batch) { create(:shipment_batch) }
    let(:expected_json_response) do
      {
        "data" => {
          "id" => shipment_batch.id,
          "type" => "shipment-batches",
          "attributes" => {
            "state" => "pending"
          }
        }
      }
    end

    before do
      allow(ShipmentLabels::BatchGenerator).to receive(:perform).and_return(shipment_batch)
      allow(described_class).to receive(:render_json).with(shipment_batch, serializer).and_return(expected_json_response)
    end

    context 'when success' do
      it 'returns http success' do
        json_post('/api/v1/shipment_labels/requests', body_params)

        expect(response).to have_http_status(:success)
      end

      it 'matches the expected response' do
        json_post('/api/v1/shipment_labels/requests', body_params)

        expect(json_response).to eq(expected_json_response)
      end
    end
  end

  describe 'GET /show' do
    let(:shipment_batch) { create(:shipment_batch) }
    let(:shipment_label) { create(:shipment_label, shipment_batch: shipment_batch) }

    context 'when success' do
      it 'returns http success' do
        json_get("/api/v1/shipment_labels/requests/#{shipment_batch.id}")

        expect(response).to have_http_status(:success)
      end

      context 'without zip_labels_file attached' do
        let(:expected_json_response) do
          {
            "data" => {
              "id" => shipment_batch.id,
              "type" => "shipment-batches",
              "attributes" => {
                "state" => "pending",
                "file-id" => nil,
                "url" => ""
              }
            }
          }
        end

        it 'matches the expected response' do
          json_get("/api/v1/shipment_labels/requests/#{shipment_batch.id}")

          expect(json_response).to eq(expected_json_response)
        end
      end

      context 'with zip_labels_file attached' do
        let(:shipment_batch) { create(:shipment_batch, :with_zip_file) }
        let(:shipment_label) { create(:shipment_label, shipment_batch: shipment_batch) }

        let(:expected_json_response) do
          {
            "data" => {
              "id" => shipment_batch.id,
              "type" => "shipment-batches",
              "attributes" => {
                "state" => "pending",
                "file-id" => shipment_batch.zip_labels_file.id,
                "url" => api_v1_shipment_labels_file_url(shipment_batch.zip_labels_file.id)
              }
            }
          }
        end

        it 'matches the expected response' do
          json_get("/api/v1/shipment_labels/requests/#{shipment_batch.id}")

          expect(json_response).to eq(expected_json_response)
        end
      end
    end

    context 'when failure' do
      context 'when record is not found' do
        let(:invalid_batch_id) { "na0b9e11-e1c2-46d8-99e6-53ac282ba13c" }

        it 'returns error details' do
          json_get("/api/v1/shipment_labels/requests/#{invalid_batch_id}")

          expect(json_response['errors'][0]['status']).to eq(404)
          expect(json_response['errors'][0]['title']).to eq('Record Not Found')
        end
      end
    end
  end
end
