# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrdersRepository
      class << self
        # write
        def save(order)
          Order::Domain::Order.new(
            AR::Order.create!(order.attributes)
          )
        end

        def apply_coupon(coupon)
          order = AR::Order.find_by(uuid: coupon.order_uuid)
          order.increment!(:discount, coupon.value)
        end

        # read
        def find(id)
          Order::Domain::Order.new(
            AR::Order.find(id)
          )
        end

        def find_by(uuid:)
          Order::Domain::Order.new(
            AR::Order.find_by(uuid: uuid)
          )
        end

        def build(params)
          Order::Domain::Order.new(
            AR::Order.new(params)
          )
        end
      end
    end
  end
end
