# frozen_string_literal: true

module Order
  module EventDenormalizers
    class ProductsAddedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository

      def products_added(event)
        order = AR::Order.find_by(uuid: event.aggregate_id)

        BasketsRepo.add_products(
          order_id: order.id,
          products: event.products
        )
      end
    end
  end
end
