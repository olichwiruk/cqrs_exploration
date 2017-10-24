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

        basket = BasketsRepo.find_or_create_by(order_id: order.id)
        basket.apply_discount(discount: discount)
        BasketsRepo.update(basket)
      end
    end
  end
end
