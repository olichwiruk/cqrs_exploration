# frozen_string_literal: true

require 'securerandom'

module Order
  module Domain
    class Order < Disposable::Twin
      include Infrastructure::Entity

      property :id
      property :uuid
      property :user_id
      property :discount

      def self.initialize(model)
        order = new(model)
        order.apply_event(
          ::Order::Events::OrderCreatedEvent.new(
            aggregate_type: to_s.split('::').last.downcase,
            aggregate_id: SecureRandom.uuid,
            user_id: order.user_id,
            discount: ::Order::Services::DiscountService.new(order).discount
          )
        )
        order
      end

      def apply_coupon(coupon)
        apply_event(
          ::Order::Events::CouponAppliedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_id: uuid,
            value: coupon.value
          )
        )
        self
      end

      # @api private
      def on_order_created(event)
        self.uuid = event.aggregate_id
      end

      # @api private
      def on_coupon_applied(event)
        self.discount += event.value
      end
    end
  end
end
