# frozen_string_literal: true

module Order
  module Domain
    class Order < ::Domain::SchemaStruct
      include ::Domain::Entity

      attribute :id, T::Coercible::Int
      attribute :uuid, T::String
      attribute :user_id, T::Coercible::Int
      attribute :completed, T::Bool
      attribute :order_lines, T::Array
      attribute :discounts, T::Array

      def self.initialize(user_id:)
        order = new
        order.apply_event(
          ::Order::Events::OrderCreatedEvent.new(
            aggregate_uuid: SecureRandom.uuid,
            user_id: user_id
          )
        )
        order
      end

      def apply_discounts(discounts)
        apply_event(
          ::Order::Events::DiscountsAppliedEvent.new(
            aggregate_uuid: uuid,
            discounts: discounts
          )
        )
        self
      end

      def add_products(products)
        apply_event(
          ::Order::Events::ProductsAddedEvent.new(
            aggregate_uuid: uuid,
            products: products
          )
        )
        self
      end

      def change_order(products)
        apply_event(
          ::Order::Events::OrderChangedEvent.new(
            aggregate_uuid: uuid,
            products: products
          )
        )
      end

      def checkout
        apply_event(
          ::Order::Events::OrderCheckedOutEvent.new(
            aggregate_uuid: uuid
          )
        )
      end

      # @api private
      def on_order_created(event)
        @uuid = event.aggregate_uuid
        @user_id = event.user_id
        @completed = false
      end

      # @api private
      def on_discounts_applied(event)
        @discounts = event.discounts
      end

      # @api private
      def on_products_added(event)
        @order_lines = event.products
      end

      # @api private
      def on_order_changed(event)
        @order_lines = event.products
      end

      # @api private
      def on_order_checked_out(_event)
        @completed = true
      end
    end
  end
end
