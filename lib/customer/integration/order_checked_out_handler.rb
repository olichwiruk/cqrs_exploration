# frozen_string_literal: true

module Customer
  module Integration
    class OrderCheckedOutHandler
      attr_reader :basket_repo, :user_repo, :order_repo

      def initialize(basket_repo, user_repo, order_repo)
        @basket_repo = basket_repo
        @user_repo = user_repo
        @order_repo = order_repo
      end

      def order_checked_out_integration(event)
        order = order_repo.by_uuid(event.order_uuid)
        user = user_repo.by_id(order.user_id)
        basket = basket_repo.by_user_id(order.user_id)

        user.give_loyalty_card
        user_repo.save(user)
        basket_repo.save(basket.restart)

        send_email(user, basket)
      end

      # @api private
      def send_email(user, basket)
        p "To: #{user.email} " \
          "Your order: #{basket.ordered_product_lines} | " \
          "#{basket.total_price} USD, #{basket.discount}% " \
          "| Final: #{basket.final_price} USD"
      end
    end
  end
end
