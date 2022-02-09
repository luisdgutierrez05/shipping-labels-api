# frozen_string_literal: false

module FakeCarrier
  module Responses
    # represents an http response from FakeCarrier
    class ApiResponse
      def initialize(http_response)
        @http_response = http_response
      end

      def success?
        status_code == 201
      end

      def failure?
        !success? && @http_response.parsed_response.key?('error')
      end

      def errors
        @http_response.parsed_response.fetch('error', [])
      end

      def body
        JSON.parse(@http_response.body)
      end

      def file_url
        body.dig("data", "attributes", "file_url")
      end

      private

      def status_code
        @http_response.code
      end
    end
  end
end
