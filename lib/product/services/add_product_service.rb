# frozen_string_literal: true

module Product
  module Services
    class AddProductService
      M = Dry::Monads
      attr_reader :product_repo

      def initialize(product_repo)
        @product_repo = product_repo
      end

      def call(params)
        validation_result = Validator.call(params.to_h)
        return M.Left(validation_result) if validation_result.failure?

        product = Product::Domain::Product.initialize(
          validation_result.output
        )
        product_repo.save(product)

        M.Right(true)
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
        end

        required(:name).filled(:str?)
        required(:quantity).filled(:int?, gteq?: 0)
        required(:price).filled(:int?, gt?: 0)
      end
    end
  end
end
