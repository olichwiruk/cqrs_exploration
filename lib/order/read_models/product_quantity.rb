# frozen_string_literal: true

module Order
  module ReadModels
    class ProductQuantity < Dry::Struct
      T = Infrastructure::Types

      attribute :id, T::Int
      attribute :price, T::Int
      attribute :quantity, T::Int

      class Composite
        def self.from_order_lines(order_lines, products)
          order_lines.map do |line|
            product = products.find { |p| p.id == line.product_id }
            Order::ReadModels::ProductQuantity.new(
              id: line.product_id,
              price: product.price,
              quantity: line.quantity
            )
          end
        end
      end
    end
  end
end
