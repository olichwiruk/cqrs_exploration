# frozen_string_literal: true

module Order
  module Domain
    class OrderLine < ::Domain::SchemaStruct
      attribute :id, T::Int
      attribute :order_id, T::Coercible::Int
      attribute :product_id, T::Coercible::Int
      attribute :quantity, T::Coercible::Int

      class Composite
        def self.from_products(products, order_id)
          products.map do |product|
            ::Order::Domain::OrderLine.new(
              id: product[:order_line_id],
              order_id: order_id,
              product_id: product[:id],
              quantity: product[:added_quantity]
            )
          end
        end
      end
    end
  end
end
