# frozen_string_literal: true

module Order
  module Domain
    module Read
      class Basket < Disposable::Twin
        feature Default

        PricingService = ::Order::Services::Domain::PricingService
        DiscountService = ::Order::Services::Domain::DiscountService

        property :id
        property :user_id
        property :products
        property :discount
        property :total_price, default: 0
        property :final_price

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

        def build(products_quantity)
          new_basket = {}
          products_quantity.each do |product|
            id = product.id
            quantity = product.quantity
            new_basket[id] = quantity
          end
          self.products = new_basket

          self.discount = DiscountService.new(user_id).sum_applicable_discounts
          self.total_price = PricingService.calculate_total(
            products_quantity: products_quantity
          )
          self.final_price = total_price * (1 - discount / 100.0)

          self
        end
      end
    end
  end
end
