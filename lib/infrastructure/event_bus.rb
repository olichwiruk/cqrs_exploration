# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = {}

    class << self
      def handlers(event_name)
        return unless @bus.include?(event_name)
        @bus.fetch(event_name).call
      end

      def register(container)
        register_handler('order_created') do
          [
            container['order.events.order_process_manager_router']
          ]
        end

        register_handler('products_added') do
          [
            container['order.events.order_process_manager_router'],
            container['customer.events.basket_generator']
          ]
        end

        register_handler('order_changed') do
          [
            container['order.events.order_process_manager_router'],
            container['customer.events.basket_generator']
          ]
        end

        register_handler('order_checked_out') do
          [
            container['order.events.order_process_manager_router'],
            container['customer.events.basket_generator'],
            container['product.events.order_checked_out_event_handler'],
            container['customer.events.order_checked_out_event_handler']
          ]
        end

        @bus.freeze
      end

      # @api private
      def register_handler(name, &block)
        @bus[name] = block
      end
    end
  end
end
