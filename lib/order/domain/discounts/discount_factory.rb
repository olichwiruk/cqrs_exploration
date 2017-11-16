# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class DiscountFactory
        class << self
          def build_total_price_discount(total_price, model)
            TotalPriceDiscount.initialize(total_price, model)
          end

          def build_first_order_discount(first_order, model)
            FirstOrderDiscount.initialize(first_order, model)
          end

          def build_loyalty_card_discount(loyalty_card, model)
            LoyaltyCardDiscount.initialize(loyalty_card, model)
          end
        end
      end
    end
  end
end
