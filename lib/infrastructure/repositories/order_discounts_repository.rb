# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderDiscountsRepository
      class << self
        def apply(order:, discounts:)
          discounts.each do |d|
            AR::OrderDiscount.create(order_id: order.id, discount_id: d.id)
          end
        end
      end
    end
  end
end
