# frozen_string_literal: true

module Order
  module CommandHandlers
    class ApplyCouponCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          order_uuid = validation_result.output[:aggregate_id]
          value = validation_result.output[:value]

          order = OrdersRepo.find_by(uuid: order_uuid)
          coupon = Order::Domain::Coupon.new(value: value)
          order.apply_coupon(coupon)
          OrdersRepo.apply_coupon(order: order, coupon: coupon)

          M.Right(true)
        end
      end
    end
  end
end
