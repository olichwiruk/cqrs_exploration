# frozen_string_literal: true

module Order
  module Services
    class CheckoutService
      M = Dry::Monads
      attr_reader :user_repo, :basket_repo, :order_repo

      def initialize(user_repo, basket_repo, order_repo)
        @user_repo = user_repo
        @basket_repo = basket_repo
        @order_repo = order_repo
      end

      def call(params)
        validation_result = Validator.call(params.to_h)
        return M.Left(validation_result) if validation_result.failure?
        user_id = validation_result.output[:user_id]

        order = order_repo.find_current(user_id)
        basket = basket_repo.by_user_id(user_id)

        command = Order::Commands::CheckoutOrderCommand.new(
          order_id: order.id
        )
        result = Infrastructure::CommandBus.send(command)

        return result if result.failure?

        user = user_repo.by_id(user_id)
        update_loyalty_card(user)
        send_email(user, basket)

        result
      end

      # @api private
      def update_loyalty_card(user)
        user.give_loyalty_card
        user_repo.save(user)
      end

      # @api private
      def send_email(user, basket)
        p "To: #{user.email} " \
          "Your order: #{basket.ordered_product_lines} | " \
          "#{basket.total_price} USD, #{basket.discount}% " \
          "| Final: #{basket.final_price} USD"
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
        end

        required(:user_id).filled(:int?, gt?: 0)
        required(:payment_method).filled(:int?, eql?: 2)
      end
    end
  end
end
