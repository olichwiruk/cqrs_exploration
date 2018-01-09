# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class FirstOrderDiscount < Discounts::Discount
        class << self
          attr_reader :first_order

          def initialize(first_order, discount)
            @first_order = first_order
            new(
              id: discount.id,
              value: discount.value,
              applicable: applicable?
            )
          end

          def applicable?
            first_order
          end
        end
      end
    end
  end
end
