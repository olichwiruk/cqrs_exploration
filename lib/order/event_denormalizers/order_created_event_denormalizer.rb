# frozen_string_literal: true

module Order
  module EventDenormalizers
    class OrderCreatedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      def order_created(event)
        # TODO
        return unless event.discount_id.nil?
        order = OrdersRepo.find_by(uuid: event.aggregate_id)
        BasketsRepo.save(order.id)
      end
    end
  end
end
