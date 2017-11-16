# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrdersRepository
      extend Infrastructure::Repositories::Repository
      @bounded_context = 'Order'

      class << self
        # read
        def find_current(user_id)
          order = find_last(user_id)
          order unless Infrastructure::Repositories::OrderProcessesRepository
              .load(order.uuid).completed
        end

        def find_last(user_id)
          Order::Domain::Order.new(
            AR::Order.where(user_id: user_id).last
          )
        end

        def first_order?(order)
          first_order = Order::Domain::Order.new(
            AR::Order.where(user_id: order.user_id).first
          )

          order.id == first_order.id
        end
      end
    end
  end
end
