# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class TotalPriceDiscount < Discounts::Discount
        def self.initialize(total_price, model)
          @total_price = total_price
          new(model, applicable?: applicable?)
        end

        def self.applicable?
          @total_price > 50
        end
      end
    end
  end
end
