# frozen_string_literal: true

require 'order/process_managers/order_process_manager'

module Order
  module Repositories
    class OrderProcessManagerRepo < ROM::Repository[:order_process_managers]
      commands :create, update: :by_pk
      struct_namespace Order::ProcessManagers

      def by_order_uuid(uuid)
        order_process_managers.where(order_uuid: uuid).one!
      end

      def create(order_uuid:)
        order_process_managers
          .command(:create)
          .call(
            order_uuid: order_uuid,
            completed: false,
            state: 0
          )
      end

      def save(pm)
        order_process_managers.by_pk(pm.id)
          .command(:update)
          .call(pm)
      end
    end
  end
end
