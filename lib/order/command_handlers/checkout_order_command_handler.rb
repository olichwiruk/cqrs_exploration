# frozen_string_literal: true

module Order
  module CommandHandlers
    class CheckoutOrderCommandHandler
      M = Dry::Monads
      attr_reader :order_repo, :event_repo

      def initialize(order_repo, event_repo)
        @order_repo = order_repo
        @event_repo = event_repo
      end

      def execute(command)
        validation_result = command.validate
        return M.Left(validation_result.errors) unless validation_result.success?

        order_id = validation_result.output[:order_id]

        order = order_repo.by_id(order_id)
        order.checkout
        order_repo.save(order)

        event_repo.publish(
          ::Order::Events::Integration::OrderCheckedOutIntegrationEvent.new(
            order_uuid: order.uuid
          )
        )

        M.Right(true)
      end
    end
  end
end
