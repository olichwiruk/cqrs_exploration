# frozen_string_literal: true

require 'securerandom'

module Order
  module ProcessManagers
    class OrderProcessManager < Disposable::Twin
      feature Default

      module StateValues
        NOT_STARTED = 0
        ORDER_CREATED = 1
        COUPON_APPLIED = 2
      end

      property :order_id
      property :completed, default: false
      property :state, default: StateValues::NOT_STARTED
      property :commands, default: []

      def order_created(event)
        raise unless state.to_i == StateValues::NOT_STARTED

        self.state = StateValues::ORDER_CREATED

        command = Order::Commands::ApplyCouponCommand.new(
          aggregate_id: event.aggregate_id,
          value: 10
        )
        add_command(command)
      end

      def coupon_applied(_event)
        self.state = StateValues::COUPON_APPLIED
        self.completed = true
      end

      # @api private
      def add_command(command)
        commands << command
      end
    end
  end
end
