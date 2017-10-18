# frozen_string_literal: true

module Order
  module ProcessManagers
    class OrderProcessManagerRouter
      OrderProcessesRepo = Infrastructure::Repositories::OrderProcessesRepository

      def order_created(event)
        pm = OrderProcessesRepo.build(order_uuid: event.aggregate_uuid)
        pm.order_created(event)
        save(pm)
      end

      def coupon_applied(event)
        pm = OrderProcessesRepo.load(event.aggregate_uuid)
        pm.coupon_applied(event)
        save(pm)
      end

      def products_added(event)
        pm = OrderProcessesRepo.load(event.aggregate_uuid)
        pm.products_added(event)
        save(pm)
      end

      def order_changed(event)
        pm = OrderProcessesRepo.load(event.aggregate_uuid)
        pm.order_changed(event)
        save(pm)
      end

      def order_checked_out(event)
        pm = OrderProcessesRepo.load(event.aggregate_uuid)
        pm.order_checked_out(event)
        save(pm)
      end

      # @api private
      def save(pm)
        OrderProcessesRepo.save(pm)
        while (command = pm.commands.shift)
          Infrastructure::CommandBus.send(command)
        end
      end
    end
  end
end
