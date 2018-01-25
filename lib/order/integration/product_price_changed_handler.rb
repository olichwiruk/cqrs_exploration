# frozen_string_literal: true

module Order
  module Integration
    class ProductPriceChangedHandler
      attr_reader :order_repo, :order_summary, :event_store

      def initialize(order_repo, order_summary, event_store)
        @order_repo = order_repo
        @order_summary = order_summary
        @event_store = event_store
      end

      def product_price_changed(event)
        orders = order_repo.find_incomplete_with_product(event.product_id)

        orders.each do |order|
          event_store.publish(
            Order::Events::Integration::OrderUpdatedIntegrationEvent.new(
              order_uuid: order.uuid,
              total_price: order_summary.total_price(order),
              discount: order_summary.discount(order)
            )
          )
        end
      end
    end
  end
end
