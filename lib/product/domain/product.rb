# frozen_string_literal: true

module Product
  module Domain
    class Product < ::Domain::SchemaStruct
      include ::Domain::Entity

      attribute :id, T::Coercible::Int
      attribute :uuid, T::String
      attribute :name, T::String
      attribute :quantity, T::Coercible::Int
      attribute :price, T::Coercible::Int

      def self.initialize(name:, quantity:, price:)
        product = new
        product.apply_event(
          ::Product::Events::ProductCreatedEvent.new(
            aggregate_uuid: SecureRandom.uuid,
            name: name,
            quantity: quantity,
            price: price
          )
        )
        product
      end

      def update(name:, quantity:, price:)
        apply_event(
          ::Product::Events::ProductUpdatedEvent.new(
            aggregate_uuid: uuid,
            name: name,
            quantity: quantity,
            price: price
          )
        )
        self
      end

      def buy(bought_quantity)
        apply_event(
          ::Product::Events::ProductBoughtEvent.new(
            aggregate_uuid: uuid,
            quantity: bought_quantity
          )
        )
        self
      end

      def on_product_created(event)
        @uuid = event.aggregate_uuid
        @name = event.name
        @price = event.price
        @quantity = event.quantity
      end

      def on_product_updated(event)
        @name = event.name
        @price = event.price
        @quantity = event.quantity
      end

      def on_product_bought(event)
        @quantity -= event.quantity
      end
    end
  end
end
