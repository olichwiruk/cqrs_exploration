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
            container['events.order_process_manager_router']
          ]
        end

        register_handler('products_added') do
          [
            container['events.order_process_manager_router'],
            container['events.basket_generator']
          ]
        end

        register_handler('order_changed') do
          [
            container['events.order_process_manager_router'],
            container['events.basket_generator']
          ]
        end

        register_handler('order_checked_out') do
          [
            container['events.order_process_manager_router'],
            container['events.basket_generator'],
            container['events.order_checked_out_event_handler']
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
