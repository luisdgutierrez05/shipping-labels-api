# frozen_string_literal: true

module ShipmentLabels
  # Class to generate shipment batch, shipment labels records and schedule BatchGeneratorJob
  class BatchGenerator
    class << self
      DEFAULT_BATCH_SIZE = 10

      def perform(data)
        shipment_batch = ShipmentBatch.create
        shipment_labels_values = shipment_labels_mapper(data, shipment_batch.id)
        import_results = shipment_labels_import(shipment_labels_values)
        return nil if import_results.failed_instances.any?

        schedule_zipfile_job(shipment_batch)
        shipment_batch
      end

      private

      def shipment_labels_mapper(shipments_data, shipment_batch_id)
        shipments_data.map do |shipment_data|
          {
            carrier_name: shipment_data[:carrier],
            shipment_details: shipment_data.except(:carrier),
            shipment_batch_id: shipment_batch_id
          }
        end
      end

      def shipment_labels_import(values)
        ShipmentLabel.import(
          values,
          batch_size: DEFAULT_BATCH_SIZE,
          all_or_none: true
        )
      end

      def schedule_zipfile_job(shipment_batch)
        ZipFileGeneratorJob.perform_later(shipment_batch.id)
        shipment_batch.enqueue!
      end
    end
  end
end
