# frozen_string_literal: true

module Order
  module Services
    module Domain
      class PricingService
        def self.calculate_total(products_quantity:, discount: 0)
          price = 0
          products_quantity.each do |product|
            price += product.quantity * product.price
          end

          price * (1 - discount / 100.0)
        end

        def self.calculate_order_total(order_id)
          order_lines = AR::OrderLine.where(order_id: order_id)
          products_quantity = []
          order_lines.each do |line|
            products_quantity << Order::Domain::ProductQuantity.new(
              id: line.product_id,
              price: AR::Product.find(line.product_id).price,
              quantity: line.quantity
            )
          end
          calculate_total(products_quantity: products_quantity)
        end
      end
    end
  end
end
