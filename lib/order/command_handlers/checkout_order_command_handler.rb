# frozen_string_literal: true

module Order
  module CommandHandlers
    class CheckoutOrderCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      class << self
        def execute(command)
          validation_result = command.validate
          return M.Left(validation_result.errors) unless validation_result.success?

          order_id = validation_result.output[:order_id]

          order = OrdersRepo.find(order_id)
          order.checkout
          OrdersRepo.update(order)

          M.Right(true)
        end
      end
    end
  end
end
