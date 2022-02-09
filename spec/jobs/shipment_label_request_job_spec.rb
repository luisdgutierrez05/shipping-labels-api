# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShipmentLabelRequestJob, type: :job do
  describe '#perform' do
    let!(:shipment_label) { create(:shipment_label, shipment_batch_id: shipment_batch.id) }
    let(:shipment_batch) { create(:shipment_batch) }

    it 'enqueues the job' do
      expect do
        described_class.perform_later(shipment_label.id)
      end.to have_enqueued_job.on_queue(:test_default)
    end

    it 'sets the shipment_label URL' do
      allow(ShipmentLabels::RequestData).to receive(:perform) { OpenStruct.new(file_url: "valid_url", failure?: false) }

      described_class.perform_now(shipment_label.id)
      expect(shipment_label.reload.file_url).to eq('valid_url')
    end

    it 'retries job on a new queue' do
      allow(ShipmentLabels::RequestData).to receive(:perform) { OpenStruct.new(failure?: true) }

      expect {
        described_class.perform_now(shipment_label.id)
      }.to have_enqueued_job.on_queue(:test_retries)
    end
  end
end
