# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrdersRepository
      extend Infrastructure::Repositories::Repository
      @bounded_context = 'Order'

      class << self
        def apply_coupon(order:, coupon:)
          AR::Order.find(order.id).increment!(:discount, coupon.value)
          order.commit
        end

        # read
        def find_current(user_id)
          order = Order::Domain::Order.new(
            AR::Order.where(user_id: user_id).last
          )
          order unless Infrastructure::Repositories::OrderProcessesRepository
              .load(order.uuid).completed
        end
      end
    end
  end
end
