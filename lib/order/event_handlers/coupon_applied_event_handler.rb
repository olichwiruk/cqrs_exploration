# frozen_string_literal: true

module Order
  module EventHandlers
    class CouponAppliedEventHandler
      def coupon_applied(event)
        Infrastructure::Repositories::OrdersRepository.apply_coupon_to_order(
          event.aggregate_uid,
          event.data['value']
        )
      end
    end
  end
end
