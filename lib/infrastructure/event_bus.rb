# frozen_string_literal: true

module Infrastructure
  class EventBus
    @bus = {
      'order_created' =>
      %w[order_process_manager_router],

      'products_added' =>
      %w[
        order_process_manager_router
        order_view_model_generator
      ],

      'order_changed' =>
      %w[
        order_process_manager_router
        order_view_model_generator
      ],

      'order_checked_out' =>
      %w[
        order_process_manager_router
        order_view_model_generator
        order_checked_out_event_handler
      ]
    }

    class << self
      def handlers(event_name)
        return unless @bus.include?(event_name)

        @bus[event_name].map { |e| container_wrapper(e) }
      end

      # @api private
      def container_wrapper(handler)
        container["events.#{handler}"]
      end

      # @api private
      def container
        MyApp.instance.container
      end
    end
  end
end
