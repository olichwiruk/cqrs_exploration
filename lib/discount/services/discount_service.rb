# frozen_string_literal: true

module Discount
  module Services
    class DiscountService
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def initialize(order_uuid)
        @order = OrdersRepo.find_by(uuid: order_uuid)
        @discount_id = nil
      end

      def discount_id
        first_order_discount
        total_price_discount
        @discount_id
      end

      # @api private
      def first_order_discount
        return unless AR::Order.count("user_id = #{@order.user_id}") == 1
        @discount_id = AR::Discount.find_by(name: 'first_order_discount').id
      end

      # @api private
      def total_price_discount
        total = 0
        lines = AR::OrderLine.where(order_id: @order.id)
        lines.each do |line|
          total += AR::Product.find(line.product_id).price * line.quantity
        end

        return unless total > 50
        @discount_id = AR::Discount.find_by(name: 'total_price_discount').id
      end
    end
  end
end
