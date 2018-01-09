# frozen_string_literal: true

module Order
  module ProcessManagers
    class OrderProcessManager < ::Domain::SchemaStruct
      attr_reader :state, :order_uuid

      module StateValues
        NOT_STARTED = 0
        ORDER_INITIALIZED = 1
        PRODUCTS_ADDED = 2
        CHECKED_OUT = 3
      end

      attribute :order_uuid, T::String
      attribute :completed, T::Bool.default(false)
      attribute :state, T::Int.default(StateValues::NOT_STARTED)
      attribute :commands, T::Array.default([])

      def order_created
        raise unless state.to_i == StateValues::NOT_STARTED
        @state = StateValues::ORDER_INITIALIZED
      end

      def products_added
        @state = StateValues::PRODUCTS_ADDED
      end

      def order_changed(event)
        event.products.keep_if { |p| p.quantity.positive? }
        @state = StateValues::ORDER_INITIALIZED if event.products.empty?
      end

      def order_checked_out
        raise unless state.to_i == StateValues::PRODUCTS_ADDED
        @state = StateValues::CHECKED_OUT
        @completed = true

        command = Order::Commands::ApplyDiscountsCommand.new(
          aggregate_uuid: order_uuid
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
