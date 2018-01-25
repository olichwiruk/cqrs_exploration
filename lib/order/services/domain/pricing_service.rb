# frozen_string_literal: true

module Order
  module Services
    module Domain
      class PricingService
        attr_reader :product_repo

        def initialize(product_repo)
          @product_repo = product_repo
        end

        def calculate(order_lines)
          products = product_repo.by_ids(order_lines.map(&:product_id))
          products_quantity = Order::ReadModels::ProductQuantity::Composite
            .from_order_lines(order_lines, products)

          calculate_total(products_quantity)
        end

        def calculate_total(products_quantity)
          products_quantity.inject(0) do |sum, product|
            sum + product.quantity * product.price
          end
        end
      end
    end
  end
end
