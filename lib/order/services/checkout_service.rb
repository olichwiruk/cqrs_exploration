# frozen_string_literal: true

module Order
  module Services
    class CheckoutService
      M = Dry::Monads
      attr_reader :user_repo, :basket_repo, :order_repo, :product_repo

      def initialize(user_repo, basket_repo, order_repo, product_repo)
        @user_repo = user_repo
        @basket_repo = basket_repo
        @order_repo = order_repo
        @product_repo = product_repo
      end

      def call(params)
        validation_result = Validator.call(params.to_h)
        return M.Left(validation_result) if validation_result.failure?
        user_id = validation_result.output[:user_id]
        order = order_repo.find_current(user_id)

        order.order_lines.each do |ol|
          return M.Left(
            OpenStruct.new(errors: { ol.product_id => 'out of stock' })
          ) unless product_repo.available_quantity?(
            ol.product_id,
            ol.quantity
          )
        end

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
