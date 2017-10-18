# frozen_string_literal: true

module Order
  module EventDenormalizers
    class DiscountAppliedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      DiscountsRepo = Infrastructure::Repositories::DiscountsRepository

      def discount_applied(event)
        return if event.discount_id == 3 # TODO: to fix
        order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
        discount = DiscountsRepo.find(event.discount_id)
        discount.value = event.discount_value

        BasketsRepo.save(order.id) # TODO
        BasketsRepo.apply_discount(
          order_id: order.id,
          discount: discount
        )
      end
    end
  end
end
