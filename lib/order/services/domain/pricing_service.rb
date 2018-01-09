# frozen_string_literal: true

module Order
  module Services
    module Domain
      class PricingService
        attr_reader :order_repo, :product_repo

        def initialize(order_repo, product_repo)
          @order_repo = order_repo
          @product_repo = product_repo
        end

        def calculate_total(products_quantity)
          products_quantity.inject(0) do |sum, product|
            sum + product.quantity * product.price
          end
        end

        def calculate_current_order(user_id)
          order_lines = order_repo.find_last(user_id).order_lines
          products_quantity = order_lines.map do |line|
            Order::Domain::ProductQuantity.new(
              id: line.product_id,
              price: product_repo.by_id(line.product_id).price,
              quantity: line.quantity
            )
          end
          calculate_total(products_quantity)
        end
      end
    end
  end
end
