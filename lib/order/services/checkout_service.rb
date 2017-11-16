# frozen_string_literal: true

module Order
  module Services
    class CheckoutService
      class << self
        M = Dry::Monads
        BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository
        OrdersRepo = Infrastructure::Repositories::OrdersRepository
        LoyaltyCardsRepo = Infrastructure::Repositories::LoyaltyCardsRepository

        def call(params)
          payment_validation = validate_payment(params['payment_method'])
          if payment_validation.success?
            user_id = params['user_id'].to_i
            basket = BasketsRepo.find_by(user_id: user_id)
            order = OrdersRepo.find_current(user_id)

            command = Order::Commands::CheckoutOrderCommand.new(
              order_id: order.id
            )
            result = Infrastructure::CommandBus.send(command)

            LoyaltyCardsRepo.save(user_id: user_id)
            send_email(basket) if result.success?
            result
          else
            payment_validation
          end
        end

        # @api private
        def send_email(basket)
          p "Your order: #{basket.products} | " \
            "#{basket.total_price} USD, #{basket.discount}% " \
            "| Final: #{basket.final_price} USD"
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
