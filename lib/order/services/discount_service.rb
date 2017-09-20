# frozen_string_literal: true

module Order
  module Services
    class DiscountService
      def initialize(order)
        @order = order
        @discount = 0
      end

      def discount
        first_order_discount
        @discount
      end

      def first_order_discount
        @discount = 10 unless AR::Order.exists?(user_id: @order.user_id)
      end
    end
  end
end
