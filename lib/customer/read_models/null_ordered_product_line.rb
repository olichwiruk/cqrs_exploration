# frozen_string_literal: true

module Customer
  module ReadModels
    class NullOrderedProductLine
      attr_reader :order_line_id, :basket_id, :product_id, :added_quantity

      def initialize(id)
        @order_line_id = nil
        @basket_id = nil
        @product_id = id
        @added_quantity = nil
      end
    end
  end
end
