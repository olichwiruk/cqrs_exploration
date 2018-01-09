# frozen_string_literal: true

module Order
  module CommandHandlers
    class AddProductsCommandHandler
      M = Dry::Monads
      attr_reader :event_store, :order_repo, :product_repo

      def initialize(event_store, order_repo, product_repo)
        @event_store = event_store
        @order_repo = order_repo
        @product_repo = product_repo
      end

      def execute(command)
        validation_result = command.validate

        return M.Left(validation_result.errors) unless validation_result.success?

        order_id = validation_result.output[:order_id]
        selected_products = validation_result.output[:selected_products]

        order_lines = map_to_order_lines(order_id, selected_products)

        order = order_repo.by_id(order_id)
        order.add_products(order_lines)

        order_repo.save(order)
        event_store.commit(order.events)
        M.Right(true)
      end

      def map_to_order_lines(order_id, selected_products)
        selected_products.map do |product|
          Order::Domain::OrderLine.new(
            id: product[:order_line_id],
            order_id: order_id,
            product_id: product[:id],
            quantity: product[:added_quantity]
          )
        end
      end
    end
  end
end
