# frozen_string_literal: true

module Customer
  module Integration
    class OrderUpdatedHandler
      attr_reader :basket_repo, :order_repo

      def initialize(basket_repo, order_repo)
        @basket_repo = basket_repo
        @order_repo = order_repo
      end

      def order_updated_integration(event)
        order = order_repo.by_uuid(event.order_uuid)
        basket = basket_repo.find_or_create(order.user_id)

        opls = Customer::ReadModels::OrderedProductLine::Composite
          .from_order_lines(order.order_lines, basket.id)

        summary = {
          total_price: event.total_price,
          discount: event.discount,
          final_price: event.total_price * (1 - event.discount / 100.0)
        }

        basket_repo.save(basket.update(opls, summary))
      end
    end
  end
end
