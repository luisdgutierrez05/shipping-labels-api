# frozen_string_literal: true

# Class to request shipment label information
class ShipmentLabelRequestJob < ApplicationJob
  queue_as :default

  rescue_from(FakeCarrier::Errors::RandomResponse) do
    retry_job queue: :retries
  end

  def perform(shipment_label_id)
    shipment_label = ShipmentLabel.find(shipment_label_id)
    result = ShipmentLabels::RequestData.perform(shipment_label.id)
    raise FakeCarrier::Errors::RandomResponse if result.failure?

    shipment_label.update(file_url: result.file_url)
  end
end
