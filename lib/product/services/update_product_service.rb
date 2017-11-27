# frozen_string_literal: true

module Product
  module Services
    class UpdateProductService
      def initialize(event_store, product_repo)
        @event_store = event_store
        @product_repo = product_repo
      end

      M = Dry::Monads

      def call(params)
        params[:product][:quantity] = params[:product][:quantity].to_i
        params[:product][:price] = params[:product][:price].to_i
        params_validation = validate(params[:product])
        return params_validation unless params_validation.success?

        product = Product::Domain::Product.new(
          @product_repo.by_id(params[:id])
        )
        product.update(params[:product].permit!.to_h.symbolize_keys)
        @product_repo.update(
          params[:id],
          product.instance_values.symbolize_keys
        )
        @event_store.commit(product.events)

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
