# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderLinesRepository
      class << self
        def save(order, products)
          products.each do |product|
            line = {
              order_id: order.id,
              product_id: product.id,
              quantity: product.quantity
            }
            line_db = AR::OrderLine.find_by(
              order_id: order.id,
              product_id: product.id
            )

            create_or_update(line_db, line)
          end

          order.commit
        end

        def change(order, products)
          products.each do |product|
            id = product.id
            quantity = product.quantity
            line_db = AR::OrderLine.find_by(
              order_id: order.id,
              product_id: id
            )
            if quantity.to_i.zero?
              line_db.destroy!
            else
              line_db.update!(quantity: quantity)
            end
          end
          order.commit
        end

        def build(params)
          Order::Domain::OrderLine.new(
            AR::OrderLine.new(params)
          )
        end

        def find_order(order_id)
          lines = []
          lines_db = AR::OrderLine.where(order_id: order_id)
          lines_db.each do |line|
            lines << build(line.attributes)
          end
          lines
        end

        # @api private
        def create_or_update(line_db, line)
          if line_db.nil?
            AR::OrderLine.create!(line)
          else
            line_db.increment!(:quantity, line[:quantity])
          end
        end
      end
    end
  end
end
