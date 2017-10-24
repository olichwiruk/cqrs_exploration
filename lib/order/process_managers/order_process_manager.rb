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

      def order_created(event)
        raise unless state.to_i == StateValues::NOT_STARTED

        self.state = StateValues::ORDER_INITIALIZED

        discounts = ::Discount::Services::DiscountService.new(order_uuid).discounts
        discounts.each do |discount|
          command = Order::Commands::ApplyDiscountCommand.new(
            aggregate_uuid: event.aggregate_uuid,
            discount: discount
          )
          add_command(command)
        end
      end

      def discount_applied(event); end

      def products_added(_event)
        self.state = StateValues::PRODUCTS_ADDED
      end

      def order_changed(event); end

      def order_checked_out(event)
        raise unless state.to_i == StateValues::PRODUCTS_ADDED

        self.state = StateValues::CHECKED_OUT
        self.completed = true

        discounts = ::Discount::Services::DiscountService.new(order_uuid).discounts
        discounts.each do |discount|
          command = Order::Commands::ApplyDiscountCommand.new(
            aggregate_uuid: event.aggregate_uuid,
            discount: discount
          )
          add_command(command)
        end
      end

      # @api private
      def add_command(command)
        commands << command
      end
    end
  end
end
