# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class LoyaltyCardDiscount < Discounts::Discount
        class << self
          attr_reader :loyalty_card

          def initialize(loyalty_card, discount)
            @loyalty_card = loyalty_card
            value = loyalty_card ? loyalty_card.discount : 0
            new(
              id: discount.id,
              value: value,
              applicable: applicable?
            )
          end

          def applicable?
            !loyalty_card.nil?
          end
        end
      end
    end
  end
end
