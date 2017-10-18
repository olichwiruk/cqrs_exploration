# frozen_string_literal: true

module Discount
  module Services
    class DiscountService
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def initialize(order_uuid)
        @order = OrdersRepo.find_by(uuid: order_uuid)
        @discount = nil
      end

      def discount
        first_order_discount
        loyalty_card_discount
        total_price_discount
        @discount
      end

      # @api private
      def first_order_discount
        discount = AR::Discount.find_by(name: 'first_order_discount')
        return unless AR::Order.count("user_id = #{@order.user_id}") == 1 &&
            !AR::OrderDiscount.exists?(order_id: @order.id, discount_id: discount.id)
        @discount = discount
      end

      # @api private
      def loyalty_card_discount
        discount = AR::Discount.find_by(name: 'loyalty_card_discount')

        return unless AR::LoyaltyCard.exists?(user_id: @order.user_id) &&
            !AR::OrderDiscount.exists?(order_id: @order.id, discount_id: discount.id)

        loyalty_card = AR::LoyaltyCard.find_by(user_id: @order.user_id)
        @discount = discount
        @discount.value = loyalty_card.discount
      end

      # @api private
      def total_price_discount
        total = 0
        lines = AR::OrderLine.where(order_id: @order.id)
        lines.each do |line|
          total += AR::Product.find(line.product_id).price * line.quantity
        end

        discount = AR::Discount.find_by(name: 'total_price_discount')

        return unless total > 50 &&
            !AR::OrderDiscount.exists?(order_id: @order.id, discount_id: discount.id)

        @discount = discount
      end
    end
  end
end
