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

      def attributes
        instance_variable_get(:@fields)
      end

      def create
        apply_event(
          ::Order::Events::OrderCreatedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_id: SecureRandom.uuid,
            user_id: user_id
          )
        )
        self
      end

      def apply_coupon(coupon)
        apply_event(
          ::Order::Events::CouponAppliedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_id: coupon.order_uuid,
            value: coupon.value
          )
        )
        coupon
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
