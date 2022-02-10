# frozen_string_literal: false

require 'rails_helper'

describe FakeCarrier::Responses::ApiResponse do
  let(:http_success_response) do
    {
      "data" => {
        "id" => "3988",
        "type" => "labels",
        "attributes" => {
          "shipment_id" => 3988,
          "tracking_number" => "67170EFEA1F364C331AD",
          "file_url" => "https://fake-carrier.s3.amazonaws.com/uagas3eehpnyw41ngpy6epmvnwbt",
          "created_at" => "2022-02-09T19:54:58.673Z"
        }
      }
    }.to_json
  end

  let(:http_failure_response) do
    { "error" => "Random response. You should handle this exception!" }.to_json
  end

  describe '#success?' do
    let(:good_response) { double('http_response', code: 201) }
    let(:bad_response) { double('http_response', code: 503) }

    context 'when the http response is a 201' do
      subject { FakeCarrier::Responses::ApiResponse.new(good_response).success? }

      it { is_expected.to be_truthy }
    end

    context 'when the http response is anything but a 201' do
      subject { FakeCarrier::Responses::ApiResponse.new(bad_response).success? }

      it { is_expected.to be_falsey }
    end
  end

  describe '#failure?' do
    subject { FakeCarrier::Responses::ApiResponse.new(response) }

    context 'when failure' do
      let(:response) { double('http_response', code: 503, parsed_response: JSON.parse(http_failure_response)) }

      it 'returns an empty string' do
        expect(subject.failure?).to be_truthy
      end
    end
  end

  describe '#errors' do
    subject { FakeCarrier::Responses::ApiResponse.new(response) }

    context 'when failure' do
      let(:response) { double('http_response', code: 503, parsed_response: JSON.parse(http_failure_response)) }

      it 'returns an empty string' do
        expect(subject.errors).to eq("Random response. You should handle this exception!")
      end
    end
  end

  describe '#body' do
    subject { FakeCarrier::Responses::ApiResponse.new(response) }

    context 'when success' do
      let(:response) do
        double('http_response', code: 200, body: http_success_response)
      end

      it { expect(subject.body).to eq(JSON.parse(http_success_response)) }
    end
  end

  describe '#file_url' do
    subject { FakeCarrier::Responses::ApiResponse.new(response) }

    context 'when success' do
      let(:response) { double('http_response', code: 200, body: http_success_response) }

      it 'returns the file url' do
        expect(subject.file_url).to eq('https://fake-carrier.s3.amazonaws.com/uagas3eehpnyw41ngpy6epmvnwbt')
      end
    end

    context 'when failure' do
      let(:response) { double('http_response', code: 503, body: http_failure_response) }

      it 'returns an empty string' do
        expect(subject.file_url).to be_nil
      end
    end
  end
end
