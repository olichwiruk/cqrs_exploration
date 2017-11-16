# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderLinesRepository
      class << self
        def save(order, products)
          products.each do |product|
            line_db = find_line(order.id, product.id)

            if line_db.nil?
              AR::OrderLine.create!(
                order_id: order.id,
                product_id: product.id,
                quantity: product.quantity
              )
            else
              line_db.update_attributes(
                quantity: line_db.quantity + product.quantity
              )
            end
          end
        end

        def change(order, products)
          lines = {}
          products.each do |product|
            line_id = AR::OrderLine.where(
              order_id: order.id,
              product_id: product.id
            ).first.id

            lines[line_id] = {
              order_id: order.id,
              product_id: product.id,
              quantity: product.quantity
            }
          end
          AR::OrderLine.update(lines.keys, lines.values)
          AR::OrderLine.where(quantity: 0).delete_all
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
        def find_line(order_id, product_id)
          AR::OrderLine.where(
            order_id: order_id,
            product_id: product_id
          ).first
        end
      end
    end
  end
end
