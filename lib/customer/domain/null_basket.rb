# frozen_string_literal: true

module Customer
  module Domain
    class NullBasket
      attr_reader :ordered_product_lines
      attr_reader :total_price, :final_price, :discount

      def initialize(products = [])
        @ordered_product_lines = ordered_products(products)
        @discount = 0
        @total_price = 0
        @final_price = 0
      end

      def nil?
        true
      end

      # @api private
      def ordered_products(products)
        products.map do |p|
          OrderedProductLine.new(
            order_line_id: p[:order_line_id],
            product_id: p[:id],
            added_quantity: p[:added_quantity]
          )
        end
      end
    end
  end
end
