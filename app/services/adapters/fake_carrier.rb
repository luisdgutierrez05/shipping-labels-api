# frozen_string_literal: true

module Adapters
  # Adapter class to handle FakerCarrier API requests
  class FakeCarrier
    REQUEST_TYPES = %w[create_shipment_label_request].freeze

    def initialize(body, request_type)
      @body = body
      @request_type = request_type.to_s
    end

    def request
      return "invalid request type" unless request_type_valid?

      request_klass = "FakeCarrier::Requests::#{@request_type.classify}".constantize
      request_klass.new(@body).request
    end

    private

    def request_type_valid?
      REQUEST_TYPES.include?(@request_type)
    end
  end
end
