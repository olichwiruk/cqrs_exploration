# frozen_string_literal: true

module Order
  module CommandHandlers
    class ApplyDiscountsCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      OrderDiscountsRepo = Infrastructure::Repositories::OrderDiscountsRepository
      EventStore = Infrastructure::WriteRepo

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          order_uuid = validation_result.output[:aggregate_uuid]
          order = OrdersRepo.find_by(uuid: order_uuid)

          discounts = ::Order::Services::Domain::DiscountService.new(
            order.user_id
          ).applicable_discounts

          order.apply_discounts(discounts)
          OrderDiscountsRepo.apply(order: order, discounts: discounts)
          EventStore.commit(order.events)

          M.Right(true)
        end
      end
    end
  end
end
