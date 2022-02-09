# frozen_string_literal: true

FactoryBot.define do
  factory :shipment_label do
    carrier_name { "fake_carrier" }
    shipment_details do
      {
        address_from: {
          name: "Fernando López",
          street1: "Av. Principal #123",
          city: "Azcapotzalco",
          province: "Ciudad de México",
          postal_code: "02900",
          country_code: "MX"
        },
        address_to: {
          name: "Isabel Arredondo",
          street1: "Av. Las Torres #123",
          city: "Puebla",
          province: "Puebla",
          postal_code: "72450",
          country_code: "MX"
        },
        parcels: [
          {
            length: 40,
            width: 40,
            height: 40,
            dimensions_unit: "CM",
            weight: 5,
            weight_unit: "KG"
          }
        ]
      }
    end
    shipment_batch
  end
end
