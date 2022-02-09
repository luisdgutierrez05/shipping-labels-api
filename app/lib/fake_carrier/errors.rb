# frozen_string_literal: false

module FakeCarrier
  module Errors
    class ServiceUnavailableError < StandardError
    end

    class RandomResponse < StandardError
    end
  end
end
