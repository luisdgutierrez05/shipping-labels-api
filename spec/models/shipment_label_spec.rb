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
require 'rails_helper'

RSpec.describe ShipmentLabel, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:shipment_batch) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:carrier_name) }
    it { is_expected.to validate_presence_of(:shipment_details) }
  end
end
