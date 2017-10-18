# frozen_string_literal: true

require 'securerandom'

module Order
  module Domain
    class Order < Disposable::Twin
      include Infrastructure::Entity

      property :id
      property :uuid
      property :user_id

      def self.initialize(model)
        order = new(model)
        order.apply_event(
          ::Order::Events::OrderCreatedEvent.new(
            aggregate_type: to_s.split('::').last.downcase,
            aggregate_uuid: SecureRandom.uuid,
            user_id: order.user_id
          )
        )
        order
      end

      def apply_discount(discount)
        apply_event(
          ::Order::Events::DiscountAppliedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_uuid: uuid,
            discount_id: discount.id
          )
        )
        self
      end

      def add_products(products)
        apply_event(
          ::Order::Events::ProductsAddedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_uuid: uuid,
            products: products
          )
        )
        self
      end

      def change_order(products)
        apply_event(
          ::Order::Events::OrderChangedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_uuid: uuid,
            products: products
          )
        )
      end

      def checkout
        apply_event(
          ::Order::Events::OrderCheckedOutEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_uuid: uuid
          )
        )
      end

      # @api private
      def on_order_created(event)
        self.uuid = event.aggregate_uuid
      end

      # @api private
      def on_discount_applied(event); end

      # @api private
      def on_products_added(event); end

      # @api private
      def on_order_changed(event); end

      # @api private
      def on_order_checked_out(event); end
    end
  end
end
