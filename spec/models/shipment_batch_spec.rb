# frozen_string_literal: true

# == Schema Information
#
# Table name: shipment_batches
#
#  id         :uuid             not null, primary key
#  state      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe ShipmentBatch, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:shipment_labels).dependent(:destroy) }
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
end
