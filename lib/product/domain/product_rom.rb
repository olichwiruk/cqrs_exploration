# frozen_string_literal: true

module Product
  module Domain
    class ProductRom
      include Infrastructure::Entity

      attr_reader :id, :uuid, :name, :quantity, :price

      def initialize(rom_struct)
        @id = rom_struct.id
        @uuid = rom_struct.uuid
        @name = rom_struct.name
        @quantity = rom_struct.quantity
        @price = rom_struct.price
      end

      def self.initialize(name:, quantity:, price:)
        product = new(OpenStruct.new)
        product.apply_event(
          ::Product::Events::ProductCreatedEvent.new(
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
            aggregate_uuid: @uuid,
            name: name,
            quantity: quantity,
            price: price
          )
        )
        self
      end

      def buy(quantity)
        apply_event(
          ::Product::Events::ProductBoughtEvent.new(
            aggregate_uuid: @uuid,
            quantity: quantity
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
        @name = event.name unless event.name.nil?
        @price = event.price unless event.price.nil?
        @quantity = event.quantity unless event.quantity.nil?
      end

      def on_product_bought(event)
        self.quantity -= event.quantity
      end
    end
  end
end
