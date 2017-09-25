# frozen_string_literal: true

module Order
  module Services
    class AddProductsToOrderService
      class << self
        M = Dry::Monads
        OrdersRepo = Infrastructure::Repositories::OrdersRepository
        LinesRepo = Infrastructure::Repositories::OrderLinesRepository

        def call(params)
          result = validate(params)
          return result unless result.success?

          basket = params.to_h[:products].reject do |_, v|
            v.empty?
          end

          order = OrdersRepo.find_current(params[:user_id])
          if order.nil?
            command = Order::Commands::CreateOrderCommand.new(
              user_id: params[:user_id]
            )
            result = Infrastructure::CommandBus.send(command)
            order = OrdersRepo.find_current(params[:user_id])
          end

          command = Order::Commands::AddProductsCommand.new(
            order_id: order.id,
            basket: basket
          )
          Infrastructure::CommandBus.send(command)
          result
        end

        # @api private
        Validator = Dry::Validation.Form do
          configure do
            config.messages = :i18n

            def positive_values?(hash)
              hash.values.all? { |v| v.empty? || v.to_i.positive? }
            end
          end

          required(:products).value(:hash?, :positive_values?)
        end

        # @api private
        def validate(params)
          validator_result = Validator.call(params.to_h)
          if validator_result.success?
            M.Right(true)
          else
            M.Left(validator_result.errors)
          end
        end
      end
    end
  end
end
