# frozen_string_literal: true

# Class to request information per each ShipmentLabel and generate zip file.
class ZipFileGeneratorJob < ApplicationJob
  # Zip file generator missing urls error.
  class ZipFileGeneratorUrlError < StandardError; end

  MAX_RETRIES = 5

  attr_reader :current_shipment_batch, :attempts

  rescue_from(ZipFileGeneratorUrlError) do
    Rails.logger.error "Retry job - number of attempts(#{attempts})"
    retry_job queue: :retries
  end

  after_perform do |job|
    if current_shipment_batch.any_shipment_labels_url_blank?
      if @attempts < MAX_RETRIES
        raise_zipfile_error
      else
        current_shipment_batch.fail!
      end
    else
      zipfile_builder = ShipmentLabels::ZipFileGenerator.new(current_shipment_batch.id)
      zipfile_builder.perform
    end
  end

  def perform(shipment_batch_id, attempts = 0)
    @attempts = attempts
    @current_shipment_batch ||= ShipmentBatch.find(shipment_batch_id)

    current_shipment_batch.shipment_labels.each do |shipment_label|
      next if shipment_label.file_url.present?

      ShipmentLabelRequestJob.perform_later(shipment_label.id)
    end
  end

  private

  def raise_zipfile_error
    shipment_label_ids = current_shipment_batch.empty_shipment_labels_urls
    i18n_path = 'services.shipment_labels.zip_file_generator.missing_urls'
    message = I18n.t(i18n_path, label_ids: shipment_label_ids.join(', '))

    Rails.logger.error "ZipFile Generator error:"
    Rails.logger.error message

    @attempts += 1

    raise ZipFileGeneratorUrlError
  end
end
