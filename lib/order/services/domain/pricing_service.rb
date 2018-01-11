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
          products = product_repo.by_ids(order_lines.map(&:product_id))
          products_quantity = Order::ReadModels::ProductQuantity::Composite
            .from_order_lines(order_lines, products)
          calculate_total(products_quantity)
        end
      end
    end
  end
end
