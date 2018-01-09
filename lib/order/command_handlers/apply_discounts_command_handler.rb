# frozen_string_literal: true

module Order
  module CommandHandlers
    class ApplyDiscountsCommandHandler
      M = Dry::Monads
      attr_reader :event_store, :order_repo, :discount_service

      def initialize(event_store, order_repo, discount_service)
        @event_store = event_store
        @order_repo = order_repo
        @discount_service = discount_service
      end

      def execute(command)
        validation_result = command.validate

        return M.Left(validation_result) if validation_result.failure?

        order_uuid = validation_result.output[:aggregate_uuid]
        order = order_repo.by_uuid(order_uuid)
        discounts = discount_service.applicable_discounts(order.user_id)

        order.apply_discounts(discounts)
        order_repo.save(order)
        event_store.commit(order.events)

        M.Right(true)
      end
    end
  end
end
