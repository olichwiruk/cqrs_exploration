# frozen_string_literal: true

module Order
  module Services
    class CheckoutService
      class << self
        M = Dry::Monads

        def call(params)
          if params['payment_method'] == '1'
            M.Left(payment: ['failed'])
          else
            M.Right(true)
          end
        end
      end
    end
  end
end
