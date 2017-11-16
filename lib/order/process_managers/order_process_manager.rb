# frozen_string_literal: true

require 'securerandom'

module Order
  module ProcessManagers
    class OrderProcessManager < Disposable::Twin
      feature Default

      module StateValues
        NOT_STARTED = 0
        ORDER_INITIALIZED = 1
        PRODUCTS_ADDED = 2
        CHECKED_OUT = 3
      end

      property :order_uuid
      property :completed, default: false
      property :state, default: StateValues::NOT_STARTED
      property :commands, default: []

      def order_created(_event)
        raise unless state.to_i == StateValues::NOT_STARTED
        self.state = StateValues::ORDER_INITIALIZED
      end

      def products_added(_event)
        self.state = StateValues::PRODUCTS_ADDED
      end

      def order_checked_out(event)
        raise unless state.to_i == StateValues::PRODUCTS_ADDED
        self.state = StateValues::CHECKED_OUT
        self.completed = true

        command = Order::Commands::ApplyDiscountsCommand.new(
          aggregate_uuid: event.aggregate_uuid
        )
        add_command(command)
      end

      # @api private
      def add_command(command)
        commands << command
      end
    end
  end
end
