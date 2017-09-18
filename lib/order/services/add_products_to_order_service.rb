# frozen_string_literal: true

module Order
  module Services
    class AddProductsToOrderService
      class << self
        M = Dry::Monads

        def call(params)
          basket = params.to_h[:products].reject do |_, v|
            v.empty?
          end
          p Infrastructure::Repositories::OrdersRepository.find_current(1)
          p basket
          validate(params)
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
