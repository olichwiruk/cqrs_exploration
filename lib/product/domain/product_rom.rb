# frozen_string_literal: true

module Product
  module Domain
    class ProductRom
      include Infrastructure::Entity

      attr_reader :id, :uuid, :name, :quantity, :price

      def self.initialize(name:, quantity:, price:)
        product = new(OpenStruct.new)
        product.apply_event(
          ::Product::Events::ProductCreatedEvent.new(
            aggregate_type: to_s.split('::').last.downcase,
            aggregate_uuid: SecureRandom.uuid,
            name: name,
            quantity: quantity,
            price: price
          )
        )
        product
      end

      def initialize(rom_struct)
        @id = rom_struct.id
        @uuid = rom_struct.uuid
        @name = rom_struct.name
        @quantity = rom_struct.quantity
        @price = rom_struct.price
      end

      def update(product_params)
        new_name = product_params['name']
        new_quantity = product_params['quantity']
        new_price = product_params['price']
        event = ::Product::Events::ProductUpdatedEvent.new(
          aggregate_type: self.class.to_s.split('::').last.downcase,
          aggregate_uuid: uuid,
          name: update_attr(name, new_name),
          quantity: update_attr(quantity, new_quantity),
          price: update_attr(price, new_price)
        )
        apply_event(event) unless event.values.empty?
        self
      end

      def buy(quantity)
        apply_event(
          ::Product::Events::ProductBoughtEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_uuid: uuid,
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
        update_from_hash(event.values)
      end

      def on_product_bought(event)
        self.quantity -= event.quantity
      end

      # @api private
      def update_attr(attr, new_attr)
        attr.eql?(new_attr) ? nil : new_attr
      end
    end
  end
end
