# frozen_string_literal: true

require 'zip'

module ShipmentLabels
  # Class to generate zip file with shipment labels pdfs
  class ZipFileGenerator
    attr_reader :shipment_batch, :zip_temporal_file, :temporal_label_files

    def initialize(shipment_batch_id)
      @temporal_label_files = []
      @shipment_batch = ShipmentBatch.find(shipment_batch_id)
      @zip_temporal_file = Tempfile.new(temporal_filename)
    end

    def perform
      # Add files to the zip file
      Zip::File.open(zip_temporal_file.path, create: true) do |zipfile|
        build_zipfiles(zipfile, shipment_batch.shipment_labels)
      end

      add_zip_file
      clear_temporal_label_files
      shipment_batch.complete!
    end

    private

    def temporal_filename
      ["batch-#{shipment_batch.id}", '.zip']
    end

    def shipment_label_filename(shipment_label_id)
      "shipment-label-#{shipment_label_id}.pdf"
    end

    def assign_file(zipfile, shipment_label_id, url)
      filename = shipment_label_filename(shipment_label_id)
      temporal_label_file = ShipmentLabels::TemporalFileGenerator.new(url).file
      temporal_label_files << temporal_label_file
      zipfile.add(filename, temporal_label_file)
    end

    def build_zipfiles(zipfile, shipment_labels)
      shipment_labels.each do |shipment_label|
        assign_file(zipfile, shipment_label.id, shipment_label.file_url)
      end
    end

    def zip_file
      File.open(zip_temporal_file.path)
    end

    def zip_filename
      File.basename(zip_temporal_file.path)
    end

    # Attach zip file into shipment batch instance
    def add_zip_file
      shipment_batch.zip_labels_file.attach(
        io: zip_file,
        content_type: 'application/zip',
        filename: zip_filename
      )

      zip_file.close
    end

    # Closes and deletes the temporal pdf files
    def clear_temporal_label_files
      temporal_label_files.each do |file|
        file.close
        file.unlink
      end
    end
  end
end
