# frozen_string_literal: true

module Order
  module CommandHandlers
    class CreateOrderCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository

      class << self
        def execute(command)
          validation_result = command.validate
          return M.Left(validation_result.errors) unless validation_result.success?

          order = OrdersRepo.build(validation_result.output)
          OrdersRepo.save(order)
          M.Right(true)
        end
      end
    end
  end
end
