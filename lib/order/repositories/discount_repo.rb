# frozen_string_literal: true

module Order
  module Repositories
    class DiscountRepo < ROM::Repository[:discounts]
      commands :create

      def create_discounts
        discounts.command(:create, result: :many).call(
          [
            { name: 'First order discount', value: 10 },
            { name: 'Total price discount', value: 10 },
            { name: 'Loyalty card discount' }
          ]
        )
      end

      def by_name(name)
        discounts.where(name: name).one!
      end
    end
  end
end
