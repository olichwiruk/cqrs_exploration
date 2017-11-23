# frozen_string_literal: true

module Product
  module Services
    class AddProductService

      def initialize(product_repo)
        @product_repo = product_repo
      end

      M = Dry::Monads
      EventStore = Infrastructure::WriteRepo

      def call(params)
        params[:quantity] = params[:quantity].to_i
        params[:price] = params[:price].to_i
        params_validation = validate(params)
        return params_validation unless params_validation.success?

        # product = ProductsRepo.build(params: params)
        product = Product::Domain::ProductRom.initialize(
          params.to_h.symbolize_keys
        )
        EventStore.commit(product.events)
        @product_repo.create(product.instance_values.symbolize_keys)

        params_validation
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

      # @api private
      def validate(params)
        validator_result = Validator.call(params)
        if validator_result.success?
          M.Right(true)
        else
          M.Left(validator_result.errors)
        end
      end
    end
  end
end
