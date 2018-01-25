# frozen_string_literal: true

module Order
  module ProcessManagers
    class OrderProcessManagerRouter
      attr_reader :order_pm_repo, :command_bus

      def initialize(order_pm_repo, command_bus)
        @order_pm_repo = order_pm_repo
        @command_bus = command_bus
      end

      def order_created(event)
        pm = order_pm_repo.create(order_uuid: event.aggregate_uuid)
        pm.order_created
        save(pm)
      end

      def products_added(event)
        pm = order_pm_repo.by_order_uuid(event.aggregate_uuid)
        pm.products_added
        save(pm)
      end

      def order_changed(event)
        pm = order_pm_repo.by_order_uuid(event.aggregate_uuid)
        pm.order_changed(event)
        save(pm)
      end

      def order_checked_out(event)
        pm = order_pm_repo.by_order_uuid(event.aggregate_uuid)
        pm.order_checked_out
        save(pm)
      end

      # @api private
      def save(pm)
        order_pm_repo.save(pm)
        while (command = pm.commands.shift)
          command_bus.send(command)
        end
      end
    end
  end
end
