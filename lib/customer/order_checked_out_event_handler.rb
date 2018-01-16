# frozen_string_literal: true

module Customer
  class OrderCheckedOutEventHandler
    attr_reader :order_repo, :user_repo

    def initialize(order_repo, user_repo)
      @order_repo = order_repo
      @user_repo = user_repo
    end

    def order_checked_out(event)
      order = order_repo.by_uuid(event.aggregate_uuid)
      user = user_repo.by_id(order.user_id)

      user.give_loyalty_card
      user_repo.save(user)

      send_email(user, order)
    end

    # @api private
    def send_email(user, order)
      p "To: #{user.email} " \
        "Your order: #{order.order_lines} | "
      # "#{basket.total_price} USD, #{basket.discount}% " \
      # "| Final: #{basket.final_price} USD"
    end
  end
end
