# frozen_string_literal: true

module Api
  module V1
    module ShipmentLabels
      # Controller allows to requests shipment labels
      class RequestsController < ApplicationController
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

        def create
          shipments_data = requests_params[:shipment_labels]
          shipment_batch = ::ShipmentLabels::BatchGenerator.perform(shipments_data)
          serializer = Api::V1::ShipmentLabels::RequestSerializer

          render_json(shipment_batch, serializer)
        end

        def show
          shipment_batch = ShipmentBatch.find(params[:id])
          serializer = Api::V1::ShipmentLabels::BatchSerializer

          render_json(shipment_batch, serializer)
        end

        private

        def address_params
          [:name, :street1, :city, :province, :postal_code, :country_code]
        end

        def parcels_params
          [:length, :width, :height, :dimensions_unit, :weight, :weight_unit]
        end

        def shipment_params
          [
            address_from: address_params,
            address_to: address_params,
            parcels: parcels_params
          ]
        end

        def requests_params
          params.require(:data).permit(
            shipment_labels: [
              :carrier,
              { shipment: shipment_params }
            ]
          )
        end
      end
    end
  end
end
