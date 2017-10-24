# frozen_string_literal: true

module Order
  module EventDenormalizers
    class OrderChangedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def order_changed(event)
        order = OrdersRepo.find_by(uuid: event.aggregate_uuid)

        basket = BasketsRepo.find_by(order_id: order.id)
        basket.change_order(
          products: event.products
        )
        BasketsRepo.update(basket)
      end
    end
  end
end
