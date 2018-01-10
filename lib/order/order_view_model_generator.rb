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

      ordered_product_lines = map_to_ordered_product_lines(basket.id, order.order_lines)
      products_quantity = map_to_products_quantity(order.order_lines)

      summary = basket_calculator
        .calculate(basket.user_id, products_quantity)
      basket.update(ordered_product_lines, summary)
    end

    # @api private
    def map_to_ordered_product_lines(basket_id, order_lines)
      order_lines.map do |ol|
        Customer::ReadModels::OrderedProductLine.new(
          order_line_id: ol.id,
          basket_id: basket_id,
          product_id: ol.product_id,
          added_quantity: ol.quantity
        )
      end
    end

    # @api private
    def map_to_products_quantity(order_lines)
      order_lines.map do |line|
        Order::ReadModels::ProductQuantity.new(
          id: line.product_id,
          price: product_repo.by_id(line.product_id).price,
          quantity: line.quantity
        )
      end
    end
  end
end
