# frozen_string_literal: false

module Api
  module V1
    module ShipmentLabels
      # Class to serialize ShipmentBatch model
      class BatchSerializer < ActiveModel::Serializer
        include Rails.application.routes.url_helpers

        attributes :id, :state, :file_id, :url

        def url
          return '' if object.zip_labels_file.blank?

          api_v1_shipment_labels_file_url(object.zip_labels_file.id)
        end

        def file_id
          return if object.zip_labels_file.blank?

          object.zip_labels_file.id
        end
      end
    end
  end
end
