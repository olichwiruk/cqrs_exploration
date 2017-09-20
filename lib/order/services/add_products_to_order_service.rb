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

          basket.each do |k, v|
            line = LinesRepo.build(
              order_id: order.id,
              product_id: k.to_i,
              quantity: v.to_i
            )
            line_db = AR::OrderLine.find_by(order_id: line.order_id, product_id: line.product_id)
            if line_db.nil?
              LinesRepo.save(line)
            else
              line_db.increment!(:quantity, line.quantity)
            end
          end

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
