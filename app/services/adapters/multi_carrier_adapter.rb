# frozen_string_literal: true

module Adapters
  # Base adapter for carrier API's
  class MultiCarrierAdapter
    attr :adapter

    delegate :request, to: :adapter

    def initialize(adapter)
      @adapter = adapter
    end
  end
end
