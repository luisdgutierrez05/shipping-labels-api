# frozen_string_literal: true

FactoryBot.define do
  factory :shipment_batch do
    trait :with_zip_file do
      zip_labels_file do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/shipment_labels/batch-example.zip'),
          'application/zip'
        )
      end
    end
  end
end
