# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderLinesRepository
      class << self
        def save(order, products)
          products.each do |id, quantity|
            line = {
              order_id: order.id,
              product_id: id.to_i,
              quantity: quantity.to_i
            }
            line_db = AR::OrderLine.find_by(
              order_id: order.id,
              product_id: id.to_i
            )

            create_or_update(line_db, line)
          end

          order.commit
        end

        def change(order, products)
          products.each do |id, quantity|
            line_db = AR::OrderLine.find_by(
              order_id: order.id,
              product_id: id.to_i
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
