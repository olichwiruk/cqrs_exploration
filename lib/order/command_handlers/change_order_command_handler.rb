# frozen_string_literal: true

module Order
  module CommandHandlers
    class ChangeOrderCommandHandler
      M = Dry::Monads
      OrdersRepo = Infrastructure::Repositories::OrdersRepository
      ProductsRepo = Infrastructure::Repositories::ProductsRepository
      OrderLinesRepo = Infrastructure::Repositories::OrderLinesRepository
      EventStore = Infrastructure::WriteRepo

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          p validation_result.output
          order_id = validation_result.output[:order_id]
          basket = validation_result.output[:basket]

          products = products_list(basket)

          order = OrdersRepo.find(order_id)
          order.change_order(products)
          p order
          OrderLinesRepo.change(order, products)
          EventStore.commit(order.events)

          M.Right(true)
        end

        def products_list(basket)
          products = []
          basket.each do |id, quantity|
            id = id.to_i
            quantity = quantity.to_i
            price = ProductsRepo.find(id).price
            products << Order::Domain::ProductQuantity.new(
              id: id,
              price: price,
              quantity: quantity
            )
          end
          products
        end
      end
    end
  end
end
