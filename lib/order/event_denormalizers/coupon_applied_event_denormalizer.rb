# frozen_string_literal: true

module Order
  module EventDenormalizers
    class CouponAppliedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      DiscountsRepo = Infrastructure::Repositories::DiscountsRepository

      def coupon_applied(event)
        return if event.discount_id == 2
        order = OrdersRepo.find_by(uuid: event.aggregate_id)
        discount = DiscountsRepo.find(event.discount_id)

        BasketsRepo.save(order.id) # TODO
        BasketsRepo.apply_coupon(
          order_id: order.id,
          discount: discount
        )
      end
    end
  end
end
