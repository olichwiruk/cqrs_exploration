# frozen_string_literal: true

require 'securerandom'

module Order
  module ProcessManagers
    class OrderProcessManager < Disposable::Twin
      feature Default

      module StateValues
        NOT_STARTED = 0
        ORDER_INITIALIZED = 1
        DISCOUNT_APPLIED = 2
        CHECKED_OUT = 3
      end

      property :order_uuid
      property :completed, default: false
      property :state, default: StateValues::NOT_STARTED
      property :commands, default: []

      def order_created(event)
        raise unless state.to_i == StateValues::NOT_STARTED

        self.state = StateValues::ORDER_INITIALIZED

        discount_id = ::Discount::Services::DiscountService.new(order_uuid).discount_id
        return if discount_id.nil?
        command = Order::Commands::ApplyDiscountCommand.new(
          aggregate_uuid: event.aggregate_uuid,
          discount_id: discount_id
        )
        add_command(command)
      end

      def discount_applied(_event)
        self.state = StateValues::DISCOUNT_APPLIED
      end

      def products_added(event); end

      def order_changed(event); end

      def order_checked_out(event)
        self.state = StateValues::CHECKED_OUT
        self.completed = true

        discount_id = ::Discount::Services::DiscountService.new(order_uuid).discount_id
        return if discount_id.nil? || discount_id == 1 # TODO
        command = Order::Commands::ApplyDiscountCommand.new(
          aggregate_uuid: event.aggregate_uuid,
          discount_id: discount_id
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
