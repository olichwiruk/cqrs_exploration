# frozen_string_literal: true

module Order
  module EventHandlers
    class OrderCreatedEventHandler
      def order_created(event)
        Infrastructure::Repositories::OrdersRepository.add_order(
          event.aggregate_uid,
          event.data
        )
      end
    end
  end
end
