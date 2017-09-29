# frozen_string_literal: true

module Order
  module CommandHandlers
    class ChangeOrderCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      OrderLinesRepo = Infrastructure::Repositories::OrderLinesRepository

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          order_id = validation_result.output[:order_id]
          products = validation_result.output[:basket]

          order = OrdersRepo.find(order_id)
          order.change_order(products)
          OrderLinesRepo.change(order, products)

          M.Right(true)
        end
      end
    end
  end
end
