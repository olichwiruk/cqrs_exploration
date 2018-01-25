# frozen_string_literal: true

module Order
  module Services
    module Domain
      class OrderSummaryService
        attr_reader :pricing_service, :discount_service

        def initialize(pricing_service, discount_service)
          @pricing_service = pricing_service
          @discount_service = discount_service
        end

        def total_price(order)
          pricing_service.calculate(order.order_lines)
        end

        def discount(order)
          discount_service.sum_applicable_discounts(order.user_id)
        end
      end
    end
  end
end
