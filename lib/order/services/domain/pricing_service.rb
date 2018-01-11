# frozen_string_literal: true

module Order
  module Services
    module Domain
      class PricingService
        def calculate_total(products_quantity)
          products_quantity.inject(0) do |sum, product|
            sum + product.quantity * product.price
          end
        end
      end
    end
  end
end
