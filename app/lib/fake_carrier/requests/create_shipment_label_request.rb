# frozen_string_literal: false

module FakeCarrier
  module Requests
    # Class to request Shipment Label information
    class CreateShipmentLabelRequest < ApiRequest
      HTTP_METHOD = :post

      def initialize(params = {})
        super(params)

        @request = self
      end

      def request
        super

        FakeCarrier::Responses::ApiResponse.new(http_response)
      end

      def url
        "#{self.class.base_uri}/#{api_version}/labels"
      end

      private

      def body
        JSON.generate(@params)
      end
    end
  end
end
