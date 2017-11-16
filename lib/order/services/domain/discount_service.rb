# frozen_string_literal: true

module Order
  module Services
    module Domain
      class DiscountService
        DiscountsRepo = Infrastructure::Repositories::DiscountsRepository
        OrdersRepo = Infrastructure::Repositories::OrdersRepository
        BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
        DiscountFactory = Order::Domain::Discounts::DiscountFactory
        PricingService = ::Order::Services::Domain::PricingService

        def initialize(user_id)
          @user_id = user_id
        end

        def order
          @order ||= OrdersRepo.find_last(@user_id)
        end

        def applicable_discounts
          all_discounts.select(&:applicable?)
        end

        def sum_applicable_discounts
          applicable_discounts.inject(0) do |sum, discount|
            sum + discount.value
          end
        end

        # @api private
        def all_discounts
          [
            DiscountFactory.build_total_price_discount(
              PricingService.calculate_order_total(order.id),
              DiscountsRepo.find_by(name: :total_price_discount)
            ),
            DiscountFactory.build_first_order_discount(
              OrdersRepo.first_order?(order),
              DiscountsRepo.find_by(name: :first_order_discount)
            ),
            DiscountFactory.build_loyalty_card_discount(
              AR::LoyaltyCard.find_by(user_id: @user_id),
              DiscountsRepo.find_by(name: :loyalty_card_discount)
            )
          ]
        end
      end
    end
  end
end
