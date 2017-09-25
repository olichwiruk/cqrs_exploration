# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderLinesRepository
      class << self
        def save(order, products)
          products.each do |k, v|
            line = build(
              order_id: order.id,
              product_id: k.to_i,
              quantity: v.to_i
            )
            line_db = AR::OrderLine.find_by(order_id: line.order_id, product_id: line.product_id)
            if line_db.nil?
              AR::OrderLine.create!(line.instance_variable_get(:@fields))
            else
              line_db.increment!(:quantity, line.quantity)
            end
          end
          order.commit
        end

        def build(params)
          Order::Domain::OrderLine.new(
            AR::OrderLine.new(params)
          )
        end
      end
    end
  end
end
