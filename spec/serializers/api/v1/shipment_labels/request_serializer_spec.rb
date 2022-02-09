# frozen_string_literal: false

require 'rails_helper'

RSpec.describe 'Api::V1::ShipmentLabels::RequestSerializer', type: :api do
  let(:shipment_batch) { FactoryBot.create(:shipment_batch) }

  subject { Api::V1::ShipmentLabels::RequestSerializer.new(shipment_batch) }

  it 'includes the expected attributes' do
    expect(subject.attributes.keys).to contain_exactly(:id, :state)
  end
end
