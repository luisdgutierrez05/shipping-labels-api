# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Adapters::FakeCarrier do
  describe '.request' do
    subject { described_class.new(OpenStruct.new, request_type) }

    let(:expected_response) do
      OpenStruct.new(code: expected_http_status, body: expected_body_response)
    end

    context 'when success' do
      let(:request_type) { 'create_shipment_label_request' }

      before do
        allow_any_instance_of(FakeCarrier::Requests::CreateShipmentLabelRequest).to receive(:request) { true }
      end

      it do
        expect(subject.request).to eq(true)
      end
    end

    context 'when failure' do
      let(:request_type) { 'not_supported_request_type' }

      it do
        expect(subject.request).to eq('invalid request type')
      end
    end
  end
end
