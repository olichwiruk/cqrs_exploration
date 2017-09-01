# frozen_string_literal: true

module Order
  module Domain
    class Coupon
      attr_reader :aggregate_uid
      attr_reader :value

      class << self
        include Infrastructure::Entity

        def apply_coupon(aggregate_uid:, value:)
          apply_event(
            ::Order::Events::CouponAppliedEvent.new(
              aggregate_uid: aggregate_uid,
              value: value
            )
          )
          self
        end

        def on_coupon_applied(event); end
      end
    end
  end
end
