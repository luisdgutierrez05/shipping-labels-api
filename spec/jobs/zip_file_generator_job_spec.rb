# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ZipFileGeneratorJob, type: :job do
  describe '#perform' do
    before do
      create(:shipment_label, shipment_batch_id: shipment_batch.id)
    end

    let(:shipment_batch) { create(:shipment_batch) }

    it 'enqueues the jobs' do
      expect do
        described_class.perform_later(shipment_batch.id)
      end.to have_enqueued_job.on_queue(:test_default)
    end

    it 'retries job on a new queue' do
      allow(ShipmentLabelRequestJob).to receive(:perform_later).and_raise(ZipFileGeneratorJob::ZipFileGeneratorUrlError.new)

      expect {
        described_class.perform_now(shipment_batch.id)
      }.to have_enqueued_job.on_queue(:test_retries)
    end

    it 'sets current_shipment_batch status as error' do
      allow(ShipmentLabelRequestJob).to receive(:perform_later).and_return(true)
      allow_any_instance_of(ShipmentLabels::ZipFileGenerator).to receive(:perform) { true }

      described_class.perform_now(shipment_batch.id, 5)
      expect(shipment_batch.reload.state).to eq('error')
    end
  end
end
