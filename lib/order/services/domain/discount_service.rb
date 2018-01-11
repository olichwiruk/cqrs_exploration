# frozen_string_literal: true

module Order
  module Services
    module Domain
      class DiscountService
        DiscountFactory = Order::Domain::Discounts::DiscountFactory

        attr_reader :user_repo, :product_repo, :order_repo
        attr_reader :discount_repo, :pricing_service

        def initialize(
          user_repo, product_repo, order_repo,
          discount_repo, pricing_service
        )
          @user_repo = user_repo
          @product_repo = product_repo
          @order_repo = order_repo
          @discount_repo = discount_repo
          @pricing_service = pricing_service
        end

        def sum_applicable_discounts(user_id)
          applicable_discounts(user_id).inject(0) do |sum, discount|
            sum + discount.value
          end
        end

        def apply_discounts_to(order)
          discounts = applicable_discounts(order.user_id)
          order.apply_discounts(discounts)
        end

        # @api private
        def applicable_discounts(user_id)
          all_discounts(user_id).select(&:applicable)
        end

        # @api private
        def all_discounts(user_id)
          [
            DiscountFactory.build_first_order_discount(
              order_repo.first_order?(user_id),
              discount_repo.by_name('First order discount')
            ),
            DiscountFactory.build_total_price_discount(
              calculate_current_order(user_id),
              discount_repo.by_name('Total price discount')
            ),
            DiscountFactory.build_loyalty_card_discount(
              user_repo.by_id(user_id).loyalty_card,
              discount_repo.by_name('Loyalty card discount')
            )
          ]
        end

        # @api private
        def calculate_current_order(user_id)
          order_lines = order_repo.find_last_order_lines(user_id)
          products = product_repo.by_ids(order_lines.map(&:product_id))
          products_quantity = Order::ReadModels::ProductQuantity::Composite
            .from_order_lines(order_lines, products)

          pricing_service.calculate_total(products_quantity)
        end
      end
    end
  end
end
