# frozen_string_literal: true

module Order
  module ProcessManagers
    class OrderProcessManagerRouter
      OrderProcessesRepo = Infrastructure::Repositories::OrderProcessesRepository

      def order_created(event)
        pm = OrderProcessesRepo.build(order_id: event.aggregate_id)
        pm.order_created(event)
        save(pm)
      end

      def coupon_applied(event)
        pm = OrderProcessesRepo.load(event.aggregate_id)
        pm.coupon_applied(event)
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
