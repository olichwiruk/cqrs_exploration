# frozen_string_literal: true

module Order
  module EventDenormalizers
    class OrderChangedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      DiscountsRepo = Infrastructure::Repositories::DiscountsRepository

      def order_changed(event)
        order = AR::Order.find_by(uuid: event.aggregate_uuid)

        basket_before = BasketsRepo.find_by(order_id: order.id)
        basket = BasketsRepo.change_order(
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
        discount = DiscountsRepo.find_by(name: 'total_price_discount')
        if basket.total_price > border_price && basket_before.total_price <= border_price
          BasketsRepo.apply_discount(order_id: basket.order_id, discount: discount)
        elsif basket.total_price <= 50 && basket_before.total_price > 50
          BasketsRepo.remove_discount(order_id: basket.order_id, discount: discount)
        end
      end
    end
  end
end
