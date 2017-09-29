# frozen_string_literal: true

module Order
  module Services
    class ChangeOrderService
      class << self
        M = Dry::Monads

        def call(params)
          params_validation = validate(params)

          return params_validation if params_validation.failure?

          command = Order::Commands::ChangeOrderCommand.new(
            order_id: params[:id],
            basket: params.to_h[:products]
          )
          Infrastructure::CommandBus.send(command)
        end

        # @api private
        Validator = Dry::Validation.Form do
          configure do
            config.messages = :i18n

            def positive_values?(hash)
              hash.values.all? { |v| v.empty? || v.to_i >= 0 }
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
