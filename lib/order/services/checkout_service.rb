# frozen_string_literal: true

module Order
  module Services
    class CheckoutService
      class << self
        M = Dry::Monads
        BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository

        def call(params)
          payment_validation = validate_payment(params['payment_method'])
          if payment_validation.success?
            order_id = params['order_id'].to_i
            command = Order::Commands::CheckoutOrderCommand.new(
              order_id: order_id
            )
            result = Infrastructure::CommandBus.send(command)

            basket = BasketsRepo.find_by(order_id: order_id)
            email = "Your order: #{basket.products} | " \
              "#{basket.total_price} USD, #{basket.discount}%"
            p email if result.success?
            result
          else
            payment_validation
          end
        end

        # @api private
        def validate_payment(payment_method)
          if payment_method == '1'
            M.Left(payment: ['failed'])
          else
            M.Right(true)
          end
        end
      end
    end
  end
end
