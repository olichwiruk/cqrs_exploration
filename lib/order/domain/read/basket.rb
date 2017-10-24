# frozen_string_literal: true

module Order
  module Domain
    module Read
      class Basket < Disposable::Twin
        DiscountsRepo = Infrastructure::Repositories::DiscountsRepository

        property :id
        property :order_id
        property :products
        property :discount
        property :total_price

        def attributes
          instance_variable_get(:@fields)
        end

        def self.initialize(model)
          basket = new(model)
          unless basket.products.nil?
            basket.products = YAML.safe_load(
              model.products.gsub(/=>/, ': ')
            )
          end
          basket
        end

        def apply_discount(discount:)
          self.discount = (self.discount || 0) + discount.value
        end

        def remove_discount(discount:)
          self.discount -= discount.value
        end

        def add_products(products:)
          price_before = total_price
          price = 0
          new_basket = self.products || {}

          products.each do |product|
            id = product.id.to_s
            quantity = product.quantity
            new_basket[id] = (new_basket[id] || 0) + quantity
            price += quantity * product.price
          end

          self.products = new_basket
          self.total_price = price

          handle_total_price_discount(before_price: price_before)
          self
        end

        def change_order(products:)
          price_before = total_price
          price = 0
          new_basket = {}

          products = products.reject do |product|
            product.quantity.zero?
          end

          products.each do |product|
            id = product.id
            quantity = product.quantity
            new_basket[id] = quantity
            price += quantity * product.price
          end

          self.products = new_basket
          self.total_price = price

          handle_total_price_discount(before_price: price_before)
          self
        end

        # @api private
        def handle_total_price_discount(border_price: 50, before_price:)
          discount = DiscountsRepo.find_by(
            name: 'total_price_discount'
          )
          if total_price > border_price &&
              (before_price.nil? || before_price <= border_price)
            apply_discount(discount: discount)
          elsif total_price <= border_price &&
              (!before_price.nil? && before_price > border_price)
            remove_discount(discount: discount)
          end
        end
      end
    end
  end
end
