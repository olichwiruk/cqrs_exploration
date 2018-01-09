# frozen_string_literal: true

module Order
  module Services
    module Domain
      class DiscountService
        DiscountFactory = Order::Domain::Discounts::DiscountFactory

        attr_reader :user_id
        attr_reader :user_repo, :order_repo, :discount_repo, :pricing_service

        def initialize(user_repo, order_repo, discount_repo, pricing_service)
          @user_repo = user_repo
          @order_repo = order_repo
          @discount_repo = discount_repo
          @pricing_service = pricing_service
        end

        def applicable_discounts(user_id)
          @user_id = user_id
          all_discounts.select(&:applicable)
        end

        def sum_applicable_discounts(user_id)
          applicable_discounts(user_id).inject(0) do |sum, discount|
            sum + discount.value
          end
        end

        # @api private
        def all_discounts
          [
            DiscountFactory.build_first_order_discount(
              order_repo.first_order?(user_id),
              discount_repo.by_name('First order discount')
            ),
            DiscountFactory.build_total_price_discount(
              pricing_service.calculate_current_order(user_id),
              discount_repo.by_name('Total price discount')
            ),
            DiscountFactory.build_loyalty_card_discount(
              user_repo.by_id(user_id).loyalty_card,
              discount_repo.by_name('Loyalty card discount')
            )
          ]
        end
      end
    end
  end
end
