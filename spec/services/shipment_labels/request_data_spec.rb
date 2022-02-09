# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShipmentLabels::RequestData do
  describe '.perform' do
    subject { described_class.perform(shipment_label.id) }
    let!(:shipment_label) { create(:shipment_label, shipment_batch_id: shipment_batch.id) }
    let(:shipment_batch) { create(:shipment_batch) }

    before do
      allow_any_instance_of(Adapters::MultiCarrierAdapter).to receive(:request) { true }
    end

    it 'calls request method on an instance of MultiCarrierAdapter' do
      expect(subject).to eq(true)
    end
  end
end
