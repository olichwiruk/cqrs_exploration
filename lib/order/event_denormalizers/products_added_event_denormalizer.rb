# frozen_string_literal: true

module Order
  module EventDenormalizers
    class ProductsAddedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      DiscountsRepo = Infrastructure::Repositories::DiscountsRepository

      def products_added(event)
        order = AR::Order.find_by(uuid: event.aggregate_id)

        basket_before = BasketsRepo.find_by(order_id: order.id)
        basket = BasketsRepo.add_products(
          order_id: order.id,
          products: event.products
        )

        apply_total_price_discount(
          border_price: 50,
          basket: basket,
          basket_before: basket_before
        )
      end

      # @api private
      def apply_total_price_discount(border_price:, basket:, basket_before:)
        discount = DiscountsRepo.find_by(name: 'total_price_coupon')
        if basket.total_price > border_price &&
            (basket_before.total_price.nil? || basket_before.total_price <= border_price)
          BasketsRepo.apply_coupon(order_id: basket.order_id, discount: discount)
        end
      end
    end
  end
end
