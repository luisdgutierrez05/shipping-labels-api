# frozen_string_literal: true

module JsonHelpers
  # Parses the response body as JSON.
  # @return [JSON] A JSON parsed response.
  def json_response
    JSON.parse(response.body)
  end

  # Shortcut for stubbing response headers for WebMock.
  # @param additional_headers [Hash] Additional headers you want to add to the default.
  # @return [Hash] A hash of header information to pass to the response of a WebMock stub.
  def json_headers(additional_headers = {})
    default = { 'Content-Type' => 'application/json' }
    default.merge(additional_headers)
  end

  # Shortcut for JSON accept headers.
  # @return [Hash] The accept header as a {Hash}.
  def json_accept_headers
    { 'Accept': 'application/json' }
  end

  # Performs the GET request with JSON specific request headers.
  # @param url [String] The url to visit with the JSON request.
  # @param params [Hash] Parameters to pass to the JSON request.
  # @param headers [Hash] Additional headers to pass to the JSON request.
  def json_get(url, params = {}, headers = {})
    get(url, params: params, headers: json_accept_headers.merge(headers))
  end

  # Performs the POST request with JSON specific request headers.
  # @param url [String] The url to visit with the JSON request.
  # @param params [Hash] Parameters to pass to the JSON request.
  # @param headers [Hash] Additional headers to pass to the JSON request.
  def json_post(url, params = {}, headers = {})
    post(url, params: params, headers: json_accept_headers.merge(headers))
  end
end
