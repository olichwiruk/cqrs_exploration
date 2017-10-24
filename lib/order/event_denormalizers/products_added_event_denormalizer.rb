# frozen_string_literal: true

module Order
  module EventDenormalizers
    class ProductsAddedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def products_added(event)
        order = OrdersRepo.find_by(uuid: event.aggregate_uuid)

        basket = BasketsRepo.find_or_create_by(order_id: order.id)
        basket.add_products(
          products: event.products
        )
        BasketsRepo.update(basket)
      end

    end
  end
end
