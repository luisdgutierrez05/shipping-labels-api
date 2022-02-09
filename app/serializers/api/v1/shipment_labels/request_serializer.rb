# frozen_string_literal: false

module Api
  module V1
    module ShipmentLabels
      # Class to serialize ShipmentBatch model
      class RequestSerializer < ActiveModel::Serializer
        attributes :id, :state
      end
    end
  end
end
