# frozen_string_literal: true

module Customer
  module ReadModels
    module Services
      class BasketCalculator
        attr_reader :pricing_service, :discount_service

        def initialize(pricing_service, discount_service)
          @pricing_service = pricing_service
          @discount_service = discount_service
        end

        def calculate(user_id, products_quantity)
          total_price = pricing_service.calculate_total(products_quantity)
          discount = discount_service.sum_applicable_discounts(user_id)

          {
            total_price: total_price,
            discount: discount,
            final_price: total_price * (1 - discount / 100.0)
          }.freeze
        end
      end
    end
  end
end
