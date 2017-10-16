# frozen_string_literal: true

module Discount
  module Services
    class DiscountService
      def initialize(order)
        @order = order
        @discount_id = nil
      end

      def discount_id
        first_order_discount
        @discount_id
      end

      def first_order_discount
        return if AR::Order.exists?(user_id: @order.user_id)
        @discount_id = AR::Discount.find_by(name: 'first_order_coupon').id
      end
    end
  end
end
