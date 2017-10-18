# frozen_string_literal: true

module Order
  module EventDenormalizers
    class OrderCreatedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def order_created(event)
        # TODO
        order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
        return if AR::Read::Basket.exists?(order_id: order.id)
        BasketsRepo.save(order.id)
      end
    end
  end
end
