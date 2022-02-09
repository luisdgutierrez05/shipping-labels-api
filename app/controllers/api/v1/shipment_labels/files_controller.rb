# frozen_string_literal: true

module Api
  module V1
    module ShipmentLabels
      # Controller allows to download zip file of requested shipment labels
      class FilesController < ApplicationController
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

        def show
          send_data(
            current_attachment.download,
            filename: current_attachment.filename.to_s,
            type: current_attachment.content_type
          )
        end

        private

        def current_attachment
          @current_attachment ||= ActiveStorage::Attachment.find(params[:id])
        end
      end
    end
  end
end
