# frozen_string_literal: true

module Order
  module Services
    class AddProductsToOrderService
      attr_reader :order_repo, :product_repo
      M = Dry::Monads

      def initialize(order_repo, product_repo)
        @order_repo = order_repo
        @product_repo = product_repo
      end

      def call(params)
        validation_result = Validator
          .with(product_repo: product_repo)
          .call(params[:basket].to_h)
        return M.Left(validation_result) if validation_result.failure?

        user_id = params[:user_id]
        products = validation_result[:products]

        order = order_repo.find_current(user_id) || create_order(user_id)

        command = Order::Commands::AddProductsCommand.new(
          order_id: order.id,
          selected_products: select_added_products(products)
        )
        Infrastructure::CommandBus.send(command)
      end

      # @api private
      def create_order(user_id)
        command = Order::Commands::CreateOrderCommand.new(
          user_id: user_id
        )
        Infrastructure::CommandBus.send(command)
        order_repo.find_current(user_id)
      end

      # @api private
      def select_added_products(products)
        products.select do |line|
          line[:added_quantity] && line[:added_quantity].positive?
        end
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
            required(:added_quantity).maybe(:int?, gt?: 0)
            required(:order_line_id).maybe(:int?, gt?: 0)

            validate(available_quantity?: %i[id added_quantity]) do |id, quantity|
              product_repo.available_quantity?(id, quantity)
            end
          end
        end
      end
    end
  end
end
