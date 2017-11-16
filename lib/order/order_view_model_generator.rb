# frozen_string_literal: true

module Order
  class OrderViewModelGenerator
    BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
    OrdersRepo = Infrastructure::Repositories::OrdersRepository
    OrderLinesRepo = Infrastructure::Repositories::OrderLinesRepository

    def products_added(event)
      order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
      basket = generate_basket(order)
      BasketsRepo.update(basket)
    end

    def order_changed(event)
      order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
      basket = generate_basket(order)
      BasketsRepo.update(basket)
    end

    def order_checked_out(event)
      order = OrdersRepo.find_by(uuid: event.aggregate_uuid)
      basket = BasketsRepo.find_by(user_id: order.user_id)
      BasketsRepo.update(restart_basket(basket))
    end

    # @api private
    def generate_basket(order)
      basket = BasketsRepo.find_or_create_by(user_id: order.user_id)
      order_lines = AR::OrderLine.where(order_id: order.id)

      products_quantity = convert_lines(order_lines)
      basket.build(products_quantity)
    end

    # @api private
    def restart_basket(basket)
      basket.products = nil
      basket.discount = 0
      basket.total_price = 0
      basket.final_price = 0
      basket
    end

    # @api private
    def convert_lines(order_lines)
      products_quantity = []
      order_lines.each do |line|
        products_quantity << Order::Domain::ProductQuantity.new(
          id: line.product_id,
          price: AR::Product.find(line.product_id).price,
          quantity: line.quantity
        )
      end
      products_quantity
    end
  end
end
