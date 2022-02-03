# frozen_string_literal: true

# Migration to create model of Shipment batches
class CreateShipmentBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :shipment_batches, id: :uuid do |t|
      t.string :state
      t.string :url

      t.timestamps
    end
  end
end
