# frozen_string_literal: true

# == Schema Information
#
# Table name: shipment_labels
#
#  id                :uuid             not null, primary key
#  shipment_batch_id :uuid             not null
#  carrier_name      :string
#  shipment_details  :jsonb            not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class ShipmentLabel < ApplicationRecord
  # Associations
  belongs_to :shipment_batch

  # Validations
  validates :carrier_name, presence: true
  validates :shipment_details, presence: true
end
