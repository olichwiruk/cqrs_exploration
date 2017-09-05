# frozen_string_literal: true

module Order
  module EventHandlers
    class OrderCreatedEventHandler
      def order_created(event)
        Infrastructure::Repositories::OrdersRepository.add_order(
          event.aggregate_uid,
          event.data
        )

        command = Order::Commands::ApplyCouponCommand.new(
          aggregate_uid: event.aggregate_uid,
          value: 10
        )

        Infrastructure::CommandBus.send(command)
      end
    end
  end
end
