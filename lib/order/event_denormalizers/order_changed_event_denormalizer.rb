# frozen_string_literal: true

module Order
  module EventDenormalizers
    class OrderChangedEventDenormalizer

      def order_changed(event)
        order = AR::Order.find_by(uuid: event.aggregate_id)
        Infrastructure::RepositoriesRead::BasketsRepository.change_order(
          order_id: order.id,
          products: event.products
        )
      end
    end
  end
end
