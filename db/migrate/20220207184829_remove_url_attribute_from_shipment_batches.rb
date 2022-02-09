# frozen_string_literal: true

# Migration to remove :url attribute to ShipmetBatch model
class RemoveUrlAttributeFromShipmentBatches < ActiveRecord::Migration[7.0]
  def change
    remove_column :shipment_batches, :url
  end
end
