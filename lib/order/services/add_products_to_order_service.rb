# frozen_string_literal: true

module Order
  module Services
    class AddProductsToOrderService
      class << self
        M = Dry::Monads
        OrdersRepo = Infrastructure::Repositories::OrdersRepository
        ProductsRepo = Infrastructure::Repositories::ProductsRepository
        LinesRepo = Infrastructure::Repositories::OrderLinesRepository

        def call(params)
          basket = params.to_h[:products].reject do |_, v|
            v.empty?
          end

          if valid?(params, basket)
            on_success(params, basket)
          else
            on_failure(params, basket)
          end
        end

        # @api private
        def on_success(params, basket)
          order = OrdersRepo.find_current(params[:user_id])
          if order.nil?
            command = Order::Commands::CreateOrderCommand.new(
              user_id: params[:user_id]
            )
            Infrastructure::CommandBus.send(command)
            order = OrdersRepo.find_current(params[:user_id])
          end

          command = Order::Commands::AddProductsCommand.new(
            order_id: order.id,
            basket: basket
          )
          Infrastructure::CommandBus.send(command)
        end

        # @api private
        def on_failure(params, basket)
          if validate(params).success?
            validate_quantity_availability(basket)
          else
            validate(params)
          end
        end

        # @api private
        def valid?(params, basket)
          validate(params).success? && validate_quantity_availability(basket).success?
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

        # @api private
        def validate_quantity_availability(basket)
          result = M.Right(true)
          basket.each do |id, quantity|
            unless ProductsRepo.available_quantity?(id, quantity)
              result = M.Left(id => ['out of stock'])
            end
          end
          result
        end
      end
    end
  end
end
