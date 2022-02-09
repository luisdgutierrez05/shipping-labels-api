# frozen_string_literal: true

# Migration to add :file_url attribute to ShipmetLabel model
class AddFileUrlToShipmentLabels < ActiveRecord::Migration[7.0]
  def change
    add_column :shipment_labels, :file_url, :string
  end
end
