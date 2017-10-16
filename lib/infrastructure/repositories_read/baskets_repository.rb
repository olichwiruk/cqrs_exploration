# frozen_string_literal: true

module Infrastructure
  module RepositoriesRead
    class BasketsRepository
      class << self
        def save(order_id)
          AR::Read::Basket.create!(order_id: order_id)
        end

        def apply_coupon(order_id:, discount:)
          AR::Read::Basket.find_by(order_id: order_id)
            .increment!(:discount, discount.value)
        end

        def remove_coupon(order_id:, discount:)
          AR::Read::Basket.find_by(order_id: order_id)
            .decrement!(:discount, discount.value)
        end

        def add_products(order_id:, products:)
          basket = AR::Read::Basket.find_by(order_id: order_id)
          price = 0
          new_basket =
            if basket.products.nil?
              {}
            else
              YAML.safe_load(basket.products.gsub(/=>/, ': '))
            end

          products.each do |id, quantity|
            id = id.to_i
            quantity = quantity.to_i
            new_basket[id] = (new_basket[id] || 0) + quantity
            price += quantity * AR::Product.find(id).price
          end

          basket.update!(products: new_basket)
          basket.increment!(:total_price, price)
        end

        def change_order(order_id:, products:)
          basket = AR::Read::Basket.find_by(order_id: order_id)
          products = products.reject do |_, v|
            v.to_i.zero?
          end
          price = 0
          new_basket = {}

          products.each do |id, quantity|
            id = id.to_i
            quantity = quantity.to_i
            new_basket[id] = quantity
            price += quantity * AR::Product.find(id).price
          end

          basket.update!(products: new_basket, total_price: price)
          basket
        end

        def find_by(order_id:)
          hash = AR::Read::Basket.find_by(
            order_id: order_id
          ).attributes
          unless hash['products'].nil?
            hash['products'] = YAML.safe_load(
              hash['products'].gsub(/=>/, ': ')
            )
          end

          Order::ReadModels::Basket.new(
            hash
          )
        end
      end
    end
  end
end
