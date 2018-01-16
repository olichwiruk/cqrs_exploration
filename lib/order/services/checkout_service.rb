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

        command = Order::Commands::CheckoutOrderCommand.new(
          order_id: order.id
        )
        Infrastructure::CommandBus.send(command)
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
