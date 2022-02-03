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
class ShipmentBatch < ApplicationRecord
  include AASM

  # Associations
  has_many :shipment_labels, dependent: :destroy

  # State Machine
  aasm column: :state do
    state :pending, initial: true
    state :processing
    state :completed
    state :error

    event :enqueue do
      transitions from: :pending, to: :processing
    end

    event :complete do
      transitions from: :processing, to: :completed
    end

    event :fail do
      transitions from: [:pending, :processing], to: :error
    end
  end
end
