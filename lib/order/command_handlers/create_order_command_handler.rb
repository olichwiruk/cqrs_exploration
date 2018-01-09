# frozen_string_literal: true

module Order
  module CommandHandlers
    class CreateOrderCommandHandler
      M = Dry::Monads
      attr_reader :event_store, :order_repo

      def initialize(event_store, order_repo)
        @event_store = event_store
        @order_repo = order_repo
      end

      def execute(command)
        validation_result = command.validate
        return M.Left(validation_result.errors) unless validation_result.success?

        order = ::Order::Domain::Order.initialize(
          validation_result.output
        )

        order_repo.create(order.to_h)
        event_store.commit(order.events)

        M.Right(true)
      end
    end
  end
end
