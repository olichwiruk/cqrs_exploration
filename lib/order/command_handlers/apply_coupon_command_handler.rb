# frozen_string_literal: true

module Order
  module CommandHandlers
    class ApplyCouponCommandHandler
      M = Dry::Monads

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          discount = Order::Domain::Coupon.apply_coupon(validation_result.output)

          M.Right(discount)
        end
      end
    end
  end
end
