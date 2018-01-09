# frozen_string_literal: true

module Order
  module CommandHandlers
    class CheckoutOrderCommandHandler
      M = Dry::Monads
      attr_reader :event_store, :order_repo

      def initialize(event_store, order_repo)
        @event_store = event_store
        @order_repo = order_repo
      end

      def execute(command)
        validation_result = command.validate
        return M.Left(validation_result.errors) unless validation_result.success?

        order_id = validation_result.output[:order_id]

        order = order_repo.by_id(order_id)
        order.checkout
        order_repo.save(order)
        event_store.commit(order.events)

        M.Right(true)
      end
    end
  end
end
