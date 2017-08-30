# frozen_string_literal: true

module Customer
  module CommandHandlers
    class ApplyDiscountCommandHandler
      M = Dry::Monads

      class << self
        def execute(command)
          validation_result = command.validate

          return M.Left(validation_result.errors) unless validation_result.success?

          discount = Customer::Domain::Discount.apply_discount(validation_result.output)

          M.Right(discount)
        end
      end
    end
  end
end
