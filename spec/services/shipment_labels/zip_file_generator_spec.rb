# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShipmentLabels::ZipFileGenerator do
  describe '#perform' do
    context 'when success' do
      subject { described_class.new(shipment_batch.id) }

      before do
        # create(:shipping_label, shipping_batch_request_id: shipping_batch_request.id, file_url: 'http://URL')
        # FileUtils.mkdir_p(tmp_folder) unless File.exist?(tmp_folder)
        # allow_any_instance_of(TempfileHandler).to receive(:call).and_return(
        #   File.new(tmp_folder.join('my.pdf'), 'w+')
        # )
      end

      let(:shipment_batch) { create(:shipment_batch, state: 'processing') }

      it 'sets shipment_batch status as complete' do
        subject.perform

        expect(shipment_batch.reload.state).to eq('completed')
      end

      it 'sets the zip_labels_file as an attachment' do
        subject.perform

        shipment_batch.reload
        expect(shipment_batch.zip_labels_file.present?).to eq(true)
        expect(shipment_batch.zip_labels_file.attachment).to be_an_instance_of(ActiveStorage::Attachment)
      end

      it 'creates a new ActiveStorage attachment' do
        expect do
          subject.perform
        end.to change(ActiveStorage::Attachment, :count).by(1)
      end
    end
  end
end
