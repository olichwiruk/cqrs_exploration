# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class FirstOrderDiscount < Discounts::Discount
        def self.initialize(first_order, model)
          @first_order = first_order
          new(model, applicable?: applicable?)
        end

        def self.applicable?
          @first_order
        end
      end
    end
  end
end
