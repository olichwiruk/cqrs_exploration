# frozen_string_literal: true

module Order
  module Services
    class ChangeOrderService
      M = Dry::Monads
      attr_reader :order_repo, :product_repo, :command_bus

      def initialize(order_repo, product_repo, command_bus)
        @order_repo = order_repo
        @product_repo = product_repo
        @command_bus = command_bus
      end

      def call(params)
        validation_result = Validator
          .with(product_repo: product_repo)
          .call(params[:basket].to_h)
        return M.Left(validation_result) if validation_result.failure?

        user_id = params[:id]
        order = order_repo.find_current(user_id)

        command = Order::Commands::ChangeOrderCommand.new(
          order_id: order.id,
          products: validation_result.output[:products]
        )
        command_bus.send(command)
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
          option :product_repo
        end

        required(:products).each do
          schema do
            required(:id).filled(:int?, gt?: 0)
            required(:added_quantity).filled(:int?, gteq?: 0)
            required(:order_line_id).filled(:int?, gt?: 0)

            validate(available_quantity?: %i[id added_quantity]) do |id, quantity|
              product_repo.available_quantity?(id, quantity)
            end
          end
        end
      end
    end
  end
end
