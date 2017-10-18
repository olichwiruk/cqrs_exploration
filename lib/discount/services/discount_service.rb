# frozen_string_literal: true

module Discount
  module Services
    class DiscountService
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def initialize(order_uuid)
        @order = OrdersRepo.find_by(uuid: order_uuid)
        @discounts = []
      end

      def discounts
        first_order_discount
        loyalty_card_discount
        total_price_discount
        @discounts
      end

      # @api private
      def first_order_discount
        discount = AR::Discount.find_by(name: 'first_order_discount')
        condition = AR::Order.count("user_id = #{@order.user_id}") == 1

        @discounts << discount if condition && !discount_applied?(discount.id)
      end

      # @api private
      def loyalty_card_discount
        discount = AR::Discount.find_by(name: 'loyalty_card_discount')
        condition = AR::LoyaltyCard.exists?(user_id: @order.user_id)

        return nil unless condition && !discount_applied?(discount.id)

        loyalty_card = AR::LoyaltyCard.find_by(user_id: @order.user_id)
        discount.value = loyalty_card.discount
        @discounts << discount
      end

      # @api private
      def total_price_discount
        discount = AR::Discount.find_by(name: 'total_price_discount')

        total = 0
        lines = AR::OrderLine.where(order_id: @order.id)
        lines.each do |line|
          total += AR::Product.find(line.product_id).price * line.quantity
        end
        condition = total > 50

        @discounts << discount if condition && !discount_applied?(discount.id)
      end

      # @api private
      def discount_applied?(discount_id)
        AR::OrderDiscount.exists?(order_id: @order.id, discount_id: discount_id)
      end
    end
  end
end
