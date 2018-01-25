# frozen_string_literal: true

module Order
  module Services
    class CheckoutService
      M = Dry::Monads
      attr_reader :order_repo, :product_repo, :command_bus

      def initialize(order_repo, product_repo, command_bus)
        @order_repo = order_repo
        @product_repo = product_repo
        @command_bus = command_bus
      end

      def call(params)
        validation_result = Validator.call(params.to_h)
        return M.Left(validation_result) if validation_result.failure?
        user_id = validation_result.output[:user_id]
        order = order_repo.find_current(user_id)

        validate_products_quantity(order.order_lines)

        command = Order::Commands::CheckoutOrderCommand.new(
          order_id: order.id
        )
        command_bus.send(command)
      end

      def validate_products_quantity(order_lines)
        order_lines.each do |ol|
          next if product_repo.available_quantity?(ol.product_id, ol.quantity)

          result = OpenStruct.new(errors: { ol.product_id => 'out of stock' })
          return M.Left(result)
        end
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
