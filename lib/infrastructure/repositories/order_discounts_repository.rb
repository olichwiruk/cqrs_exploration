# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderDiscountsRepository
      class << self
        def apply(order:, discount:)
          AR::OrderDiscount.create(order_id: order.id, discount_id: discount.id)

          order.commit
        end
      end
    end
  end
end
