# frozen_string_literal: true

module Order
  module Generators
    class DraftOrderGenerator
      attr_reader :product_repo, :order_repo, :basket_repo

      def initialize(
        product_repo,
        order_repo,
        basket_repo
      )

        @product_repo = product_repo
        @order_repo = order_repo
        @basket_repo = basket_repo
      end

      def with_all_products(user_id)
        basket = basket_repo.by_user_id(user_id)

        products = product_repo.all_products.map do |p|
          ol = basket.ordered_product_lines.find do |ol_product|
            ol_product.product_id == p.id
          end || Customer::ReadModels::NullOrderedProductLine.new(p.id)

          build_offered_product(p, ol, basket.discount)
        end

        build_draft_order(
          user_id: user_id,
          basket: basket,
          products: products
        )
      end

      def with_ordered_products(user_id)
        build_ordered_products(
          user_id: user_id,
          basket: basket_repo.by_user_id(user_id)
        )
      end

      def failure(user_id, basket)
        build_ordered_products(user_id: user_id, basket: basket)
      end

      # @api private
      def build_ordered_products(user_id:, basket:)
        db_products = product_repo.by_ids(
          basket.ordered_product_lines.map(&:product_id)
        )

        products = basket.ordered_product_lines.map do |ol|
          p = db_products.find { |db_p| db_p.id == ol.product_id }
          build_offered_product(p, ol, basket.discount)
        end

        build_draft_order(
          user_id: user_id,
          basket: basket,
          products: products
        )
      end

      # @api private
      def build_offered_product(product, order_line, discount)
        Product::ReadModels::OfferedProduct.new(
          id: product.id,
          name: product.name,
          quantity: product.quantity,
          price: product.price,
          discount: discount,
          added_quantity: order_line.added_quantity,
          order_line_id: order_line.order_line_id
        )
      end

      # @api private
      def build_draft_order(user_id:, basket:, products:)
        Order::ReadModels::DraftOrder.new(
          user_id: user_id,
          discount: basket.discount,
          total_price: basket.total_price,
          final_price: basket.final_price,
          products: products
        )
      end
    end
  end
end
