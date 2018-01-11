# frozen_string_literal: true

module Order
  module CommandHandlers
    class CreateOrderCommandHandler
      M = Dry::Monads
      attr_reader :order_repo

      def initialize(order_repo)
        @order_repo = order_repo
      end

      def execute(command)
        validation_result = command.validate
        return M.Left(validation_result.errors) unless validation_result.success?

        order = ::Order::Domain::Order.initialize(
          validation_result.output
        )
        order_repo.save(order)

        M.Right(true)
      end
    end
  end
end
