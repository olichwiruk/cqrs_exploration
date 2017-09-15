# frozen_string_literal: true

module Product
  module Domain
    class Product < Disposable::Twin
      include Infrastructure::Entity
      feature Default

      property :id
      property :uuid
      property :name
      property :quantity, default: 0
      property :price

      def attributes
        instance_variable_get(:@fields)
      end

      def create
        apply_event(
          ::Product::Events::ProductCreatedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_id: SecureRandom.uuid,
            name: name,
            quantity: quantity,
            price: price
          )
        )
        self
      end

      def on_product_created(event)
        self.uuid = event.aggregate_id
      end
    end
  end
end
