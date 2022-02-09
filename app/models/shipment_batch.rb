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
class ShipmentBatch < ApplicationRecord
  include AASM

  # Associations
  has_many :shipment_labels, dependent: :destroy
  has_one_attached :zip_labels_file

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

  # Instance methods
  def any_shipment_labels_url_blank?
    shipment_labels.map(&:file_url).any?(&:blank?)
  end

  def empty_shipment_labels_urls
    shipment_labels.select { |label| label.file_url.nil? }.pluck(:id)
  end
end
