# frozen_string_literal: true

# == Schema Information
#
# Table name: shipment_batches
#
#  id         :uuid             not null, primary key
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe ShipmentBatch, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:shipment_labels).dependent(:destroy) }
    it { is_expected.to have_one_attached(:zip_labels_file) }
  end

  describe 'State machine' do
    context 'states' do
      let(:shipment_batch) { FactoryBot.create(:shipment_batch) }

      context 'initial state' do
        subject { shipment_batch }

        it { is_expected.to have_state(:pending) }
      end

      context 'processing' do
        subject { shipment_batch.processing? }

        it { subject }
      end
    end

    context 'transitions' do
      it { is_expected.to transition_from(:pending).to(:processing).on_event(:enqueue) }
      it { is_expected.to transition_from(:processing).to(:completed).on_event(:complete) }
      it { is_expected.to transition_from(:pending).to(:error).on_event(:fail) }
      it { is_expected.to transition_from(:processing).to(:error).on_event(:fail) }
    end

    context 'events' do
      let(:shipment_batch) { FactoryBot.create(:shipment_batch) }

      it 'allows event :enqueue' do
        expect(shipment_batch).to allow_event(:enqueue)
      end

      it 'allows event :complete' do
        shipment_batch.enqueue

        expect(shipment_batch).to allow_event(:complete)
      end

      it 'allows event :fail' do
        expect(shipment_batch).to allow_event(:fail)
      end
    end
  end

  describe 'Instance methods' do
    describe '#any_shipment_labels_url_blank?' do
      let(:shipment_batch) { FactoryBot.create(:shipment_batch) }

      context 'when one of shipment labels have an empty url' do
        let(:shipment_label) { FactoryBot.create(:shipment_label, shipment_batch: shipment_batch) }

        it 'returns true' do
          expect(shipment_label.file_url).to be_nil
          expect(shipment_batch.any_shipment_labels_url_blank?).to be_truthy
        end
      end

      context 'when all shipment labels have urls' do
        let(:shipment_label) { FactoryBot.create(:shipment_label, :with_url, shipment_batch: shipment_batch) }

        it 'returns false' do
          expect(shipment_label.file_url).not_to be_nil
          expect(shipment_batch.any_shipment_labels_url_blank?).to be_falsey
        end
      end
    end

    describe '#empty_shipment_labels_urls' do
      let(:shipment_batch) { FactoryBot.create(:shipment_batch) }

      context 'when some shipment labels have empty file_url attribute' do
        let(:shipment_label) { FactoryBot.create(:shipment_label, shipment_batch: shipment_batch) }

        it 'returns an array of shipment label ids' do
          shipment_label.reload

          expect(shipment_batch.empty_shipment_labels_urls).to eq([shipment_label.id])
        end
      end

      context 'when all shipment labels have file_url attribute' do
        let(:shipment_label) { FactoryBot.create(:shipment_label, :with_url, shipment_batch: shipment_batch) }

        it 'returns an empty array' do
          expect(shipment_batch.empty_shipment_labels_urls).to eq([])
        end
      end
    end
  end
end
