# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class TotalPriceDiscount < Discounts::Discount
        class << self
          attr_reader :total_price

          def initialize(total_price, discount)
            @total_price = total_price
            new(
              id: discount.id,
              value: discount.value,
              applicable: applicable?
            )
          end

          def applicable?
            total_price > 50
          end
        end
      end
    end
  end
end
