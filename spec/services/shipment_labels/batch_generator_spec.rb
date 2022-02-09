# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShipmentLabels::BatchGenerator do
  describe '.perform' do
    subject { described_class.perform(params) }

    let(:params) do
      [
        {
          carrier: 'carrier_1',
          shipment_data: 'shipment details'
        },
        {
          carrier: 'carrier_2',
          shipment_data: 'shipment details'
        }
      ]
    end

    before do
      allow(ZipFileGeneratorJob).to receive(:perform_later).and_return(true)
      allow_any_instance_of(ShipmentBatch).to receive(:enqueue!).and_return(true)
    end

    it 'creates a new shipping_batch record' do
      expect do
        subject
      end.to change(ShipmentBatch, :count).by(1)
    end

    it 'creates 2 new shipment_label records' do
      expect do
        subject
      end.to change(ShipmentLabel, :count).by(2)
    end
  end
end
