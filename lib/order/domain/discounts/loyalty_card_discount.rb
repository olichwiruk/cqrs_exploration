# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class LoyaltyCardDiscount < Discounts::Discount
        def self.initialize(loyalty_card, model)
          @loyalty_card = loyalty_card
          model.value = loyalty_card.discount unless loyalty_card.nil?
          new(model, applicable?: applicable?)
        end

        def self.applicable?
          !@loyalty_card.nil?
        end
      end
    end
  end
end
