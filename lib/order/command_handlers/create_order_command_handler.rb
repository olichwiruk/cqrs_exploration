# frozen_string_literal: true

module Order
  module CommandHandlers
    class CreateOrderCommandHandler
      M = Dry::Monads

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          order = Order::Domain::Order.create_new_order(validation_result.output)

          M.Right(order)
        end
      end
    end
  end
end
