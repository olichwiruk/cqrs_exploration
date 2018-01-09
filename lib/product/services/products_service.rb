# frozen_string_literal: true

module Product
  module Services
    class ProductsService
      attr_reader :add_product, :update_product

      def initialize(add_product, update_product)
        @add_product = add_product
        @update_product = update_product
      end
    end
  end
end
