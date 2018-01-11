# frozen_string_literal: true

module Order
  class OrderViewModelGenerator
    attr_reader :basket_repo, :order_repo, :product_repo
    attr_reader :basket_calculator

    def initialize(basket_repo, order_repo, product_repo, basket_calculator)
      @basket_repo = basket_repo
      @order_repo = order_repo
      @product_repo = product_repo
      @basket_calculator = basket_calculator
    end

    def products_added(event)
      order = order_repo.by_uuid(event.aggregate_uuid)
      basket = generate_refreshed_basket(order)
      basket_repo.save(basket)
    end

    def order_changed(event)
      order = order_repo.by_uuid(event.aggregate_uuid)
      basket = generate_refreshed_basket(order)
      basket_repo.save(basket)
    end

    def order_checked_out(event)
      order = order_repo.by_uuid(event.aggregate_uuid)

      basket = basket_repo.by_user_id(order.user_id)
      basket_repo.save(basket.restart)
    end

    # @api private
    def generate_refreshed_basket(order)
      basket = basket_repo.find_or_create(order.user_id)

      opls = Customer::ReadModels::OrderedProductLine::Composite
        .from_order_lines(order.order_lines, basket.id)
      products_quantity = map_to_products_quantity(order.order_lines)

      summary = basket_calculator
        .calculate(basket.user_id, products_quantity)
      basket.update(opls, summary)
    end

    # @api private
    def map_to_products_quantity(order_lines)
      products = product_repo.by_ids(order_lines.map(&:product_id))
      Order::ReadModels::ProductQuantity::Composite
        .from_order_lines(order_lines, products)
    end
  end
end
