# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::ShipmentLabels::Files", type: :request do
  describe "GET /show" do
    context 'when success' do
      let(:shipment_batch) { create(:shipment_batch, :with_zip_file) }

      before do
        allow(ActiveStorage::Attachment).to receive(:find).and_return(shipment_batch.zip_labels_file)
      end

      it "returns http success" do
        json_get("/api/v1/shipment_labels/files/#{shipment_batch.zip_labels_file.id}")

        expect(response).to have_http_status(:success)
      end
    end

    context 'when failure' do
      context 'when record is not found' do
        let(:invalid_batch_id) { "fa0b9e88-e3c1-20d8-11e6-53ac282ba12x" }

        it 'returns error details' do
          json_get("/api/v1/shipment_labels/files/#{invalid_batch_id}")

          expect(json_response['errors'][0]['status']).to eq(404)
          expect(json_response['errors'][0]['title']).to eq('Record Not Found')
        end
      end
    end
  end
end
