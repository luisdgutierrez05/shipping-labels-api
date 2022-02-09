# frozen_string_literal: false

require 'httparty'

module FakeCarrier
  module Requests
    # Base class to handle request for FakeCarrier API.
    class ApiRequest
      include HTTParty
      base_uri Rails.application.credentials.fake_carrier.base_api_url

      attr_reader :http_response

      HTTP_METHOD = nil

      def initialize(params = {})
        @params = params
      end

      def request
        @http_response = @request.class.send(
          @request.class::HTTP_METHOD,
          @request.url,
          @request.options
        )

        log_request
        http_response
      end

      def url
        raise NotImplementedError, "This #{self.class} cannot respond to: 'url'"
      end

      def options
        {
          headers: default_headers,
          body: body
        }
      end

      private

      def api_version
        Rails.application.credentials.fake_carrier.api_version
      end

      def access_token
        Rails.application.credentials.fake_carrier.access_token
      end

      def default_headers
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=#{access_token}"
        }
      end

      def body
        {}
      end

      def status
        http_response.code == 200 ? 'success' : 'failure'
      end

      def log_request
        Rails.logger.info "Method: #{self.class::HTTP_METHOD}"
        Rails.logger.info "Source: #{self.class.name}"
        Rails.logger.info "Response code: #{http_response.code}"
        Rails.logger.info "Response status: #{status}"
      end
    end
  end
end
