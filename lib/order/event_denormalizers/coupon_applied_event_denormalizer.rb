# frozen_string_literal: true

module Order
  module EventDenormalizers
    class CouponAppliedEventDenormalizer
      BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository

      def coupon_applied(event)
        order = AR::Order.find_by(uuid: event.aggregate_id)

        BasketsRepo.save(order.id) # TODO
        BasketsRepo.apply_coupon(
          order_id: order.id,
          value: event.value
        )
      end
    end
  end
end
