# frozen_string_literal: true

# Migration to create model of Shipment labels
class CreateShipmentLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :shipment_labels, id: :uuid do |t|
      t.references :shipment_batch, null: false, foreign_key: true, type: :uuid
      t.string :carrier_name
      t.jsonb :shipment_details, null: false, default: {}

      t.timestamps
    end
  end
end
