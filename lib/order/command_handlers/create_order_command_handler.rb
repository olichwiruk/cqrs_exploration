# frozen_string_literal: true

module Order
  module CommandHandlers
    class CreateOrderCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      EventStore = Infrastructure::WriteRepo

      class << self
        def execute(command)
          validation_result = command.validate
          return M.Left(validation_result.errors) unless validation_result.success?

          order = OrdersRepo.build(
            uuid: command.uuid,
            params: validation_result.output
          )
          OrdersRepo.save(order)
          EventStore.commit(order.events)
          M.Right(true)
        end
      end
    end
  end
end
