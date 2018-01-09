# frozen_string_literal: true

module Order
  module Services
    class BasketService
      attr_reader :add_products_to_order, :change_order, :checkout

      def initialize(add_products_to_order, change_order, checkout)
        @add_products_to_order = add_products_to_order
        @change_order = change_order
        @checkout = checkout
      end
    end
  end
end
