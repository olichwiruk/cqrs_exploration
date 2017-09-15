# frozen_string_literal: true

class UpdateProductService
  class << self
    M = Dry::Monads
    ProductsRepo = Infrastructure::Repositories::ProductsRepository

    def call(params)
      params[:product][:quantity] = params[:product][:quantity].to_i
      params[:product][:price] = params[:product][:price].to_i
      params_validation = validate(params[:product])
      return params_validation unless params_validation.success?

      Infrastructure::DomainRepository.begin
      product = ProductsRepo.find(params[:id])
      product.update(params[:product])
      ProductsRepo.update(product)
      Infrastructure::DomainRepository.commit

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
