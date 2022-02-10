# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FakeCarrier::Requests::CreateShipmentLabelRequest do
  let(:params) do
    {
      "shipment": {
        "address_from": {
          "name": "Fernando López",
          "street1": "Av. Principal #123",
          "city": "Azcapotzalco",
          "province": "Ciudad de México",
          "postal_code": "02900",
          "country_code": "MX"
        },
        "address_to": {
          "name": "Isabel Arredondo",
          "street1": "Av. Las Torres #123",
          "city": "Puebla",
          "province": "Puebla",
          "postal_code": "72450",
          "country_code": "MX"
        },
        "parcels": [
          {
            "length": 40,
            "width": 40,
            "height": 40,
            "dimensions_unit": "CM",
            "weight": 5,
            "weight_unit": "KG"
          }
        ]
      }
    }
  end

  let(:url) { "#{Rails.application.credentials.fake_carrier.base_api_url}/#{Rails.application.credentials.fake_carrier.api_version}/labels" }

  subject(:api_request) { FakeCarrier::Requests::CreateShipmentLabelRequest.new(params) }

  before { Rails.cache.clear }

  describe '::HTTP_METHOD' do
    subject { FakeCarrier::Requests::CreateShipmentLabelRequest::HTTP_METHOD }

    it { is_expected.to eq(:post) }
  end

  describe '#request' do
    subject(:request) { api_request.request }

    let(:options) do
      {
        headers: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL"
        },
        body: params.to_json
      }
    end

    before do
      stub_create_shipment_label_request
    end

    it { is_expected.to be_a(FakeCarrier::Responses::ApiResponse) }

    it 'calls FakeCarrier::Requests::ApiRequest.post' do
      expect(FakeCarrier::Requests::ApiRequest).to receive(:post).with(url, options)

      request
    end
  end

  describe '#url' do
    subject { api_request.url }

    it { is_expected.to eq(url) }
  end
end

def stub_create_shipment_label_request
  url = FakeCarrier::Requests::CreateShipmentLabelRequest.new.send(:url)
  response = double('http_response',
    status: 201,
    code: 200,
    body: {
      data: {
        id: "3988",
        type: "labels",
        attributes: {
          shipment_id: 3988,
          tracking_number: "67170EFEA1F364C331AD",
          file_url: "https://fake-carrier.s3.amazonaws.com/uagas3eehpnyw41ngpy6epmvnwbt",
          created_at: "2022-02-09T19:54:58.673Z"
        }
      }
    }.to_json,
    headers: { 'Content-Type' => 'application/json' }
  )

  allow(FakeCarrier::Requests::ApiRequest).to receive(:post).with(url, options).and_return(response)
end
