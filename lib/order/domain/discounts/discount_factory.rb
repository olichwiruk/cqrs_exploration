# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class DiscountFactory
        class << self
          def build_total_price_discount(total_price, discount)
            Discounts::TotalPriceDiscount.initialize(total_price, discount)
          end

          def build_first_order_discount(first_order, discount)
            Discounts::FirstOrderDiscount.initialize(first_order, discount)
          end

          def build_loyalty_card_discount(loyalty_card, discount)
            Discounts::LoyaltyCardDiscount.initialize(loyalty_card, discount)
          end
        end
      end
    end
  end
end
