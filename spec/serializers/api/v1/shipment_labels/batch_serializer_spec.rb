# frozen_string_literal: false

require 'rails_helper'

RSpec.describe 'Api::V1::ShipmentLabels::BatchSerializer', type: :api do
  let(:shipment_batch) { FactoryBot.create(:shipment_batch) }

  subject { Api::V1::ShipmentLabels::BatchSerializer.new(shipment_batch) }

  it 'includes the expected attributes' do
    expect(subject.attributes.keys).to contain_exactly(:id, :state, :file_id, :url)
  end

  describe '#url' do
    context 'when there is no zip_labels_file attached' do
      it 'returns an empty string' do
        expect(subject.url).to be_empty
      end
    end

    context 'when there is a zip_labels_file attached' do
      let(:shipment_batch) { FactoryBot.create(:shipment_batch, :with_zip_file) }
      let(:serializer) { Api::V1::ShipmentLabels::BatchSerializer.new(shipment_batch) }

      it 'returns the file url' do
        expect(subject.url).to eq(api_v1_shipment_labels_file_url(shipment_batch.zip_labels_file.id))
      end
    end
  end

  describe '#file_id' do
    context 'when there is no zip_labels_file attached' do
      it 'returns nil' do
        expect(subject.file_id).to be_nil
      end
    end

    context 'when there is a zip_labels_file attached' do
      let(:shipment_batch) { FactoryBot.create(:shipment_batch, :with_zip_file) }
      let(:serializer) { Api::V1::ShipmentLabels::BatchSerializer.new(shipment_batch) }

      it 'returns the file id' do
        expect(subject.file_id).to eq(shipment_batch.zip_labels_file.id)
      end
    end
  end
end
