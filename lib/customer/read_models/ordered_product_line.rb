# frozen_string_literal: true

module Customer
  module ReadModels
    class OrderedProductLine < ::Domain::SchemaStruct
      attribute :order_line_id, T::Int
      attribute :basket_id, T::Coercible::Int
      attribute :product_id, T::Coercible::Int
      attribute :added_quantity, T::Coercible::Int

      class Composite
        def self.from_order_lines(order_lines, basket_id)
          order_lines.map do |line|
            Customer::ReadModels::OrderedProductLine.new(
              order_line_id: line.id,
              basket_id: basket_id,
              product_id: line.product_id,
              added_quantity: line.quantity
            )
          end
        end
      end
    end
  end
end
