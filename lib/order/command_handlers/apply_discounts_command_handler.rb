# frozen_string_literal: true

module Order
  module CommandHandlers
    class ApplyDiscountsCommandHandler
      M = Dry::Monads
      attr_reader :order_repo, :discount_service

      def initialize(order_repo, discount_service)
        @order_repo = order_repo
        @discount_service = discount_service
      end

      def execute(command)
        validation_result = command.validate

        return M.Left(validation_result) if validation_result.failure?

        order_uuid = validation_result.output[:aggregate_uuid]

        order = order_repo.by_uuid(order_uuid)
        discount_service.apply_discounts_to(order)
        order_repo.save(order)

        M.Right(true)
      end
    end
  end
end
