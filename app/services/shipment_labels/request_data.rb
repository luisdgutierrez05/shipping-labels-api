# frozen_string_literal: true

module ShipmentLabels
  # Class to implement carrier base apdater and create shipment label request
  class RequestData
    class << self
      def perform(shipment_label_id)
        shipment_label = ShipmentLabel.find(shipment_label_id)
        adapter_instance = create_request_adapter(shipment_label)
        adaptee = Adapters::MultiCarrierAdapter.new(adapter_instance)
        adaptee.request
      end

      private

      def adapter_klass(shipment_label)
        "Adapters::#{shipment_label.carrier_name.classify}".constantize
      end

      def create_request_adapter(shipment_label)
        klass = adapter_klass(shipment_label)
        klass.new(shipment_label.shipment_details, :create_shipment_label_request)
      end
    end
  end
end
