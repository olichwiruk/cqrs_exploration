# frozen_string_literal: true

module Product
  module Services
    class UpdateWarehouseService
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      OrderLinesRepo = Infrastructure::Repositories::OrderLinesRepository
      ProductsRepo = Infrastructure::Repositories::ProductsRepository
      EventStore = Infrastructure::WriteRepo

      def order_checked_out(event)
        order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
        lines = OrderLinesRepo.find_order(order.id)
        lines.each do |line|
          product = ProductsRepo.find(line.product_id)
          product.buy(line.quantity)
          ProductsRepo.update(product)
          EventStore.commit(product.events)
        end
      end
    end
  end
end
