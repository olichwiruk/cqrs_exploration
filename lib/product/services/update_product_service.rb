# frozen_string_literal: true

module Product
  module Services
    class UpdateProductService
      M = Dry::Monads
      attr_reader :product_repo, :event_store

      def initialize(product_repo, event_store)
        @product_repo = product_repo
        @event_store = event_store
      end

      def call(params)
        validation_result = Validator.call(params.to_h)
        return M.Left(validation_result) if validation_result.failure?

        product = product_repo.by_id(params[:id])
        old_price = product.price
        new_price = validation_result.output[:product][:price]

        product.update(validation_result.output[:product])
        product_repo.save(product)

        if new_price != old_price
          event_store.publish(
            Product::Events::Integration::ProductPriceChangedEvent.new(
              product_id: product.id
            )
          )
        end

        M.Right(true)
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
        end

        required(:product).schema do
          required(:name).filled(:str?)
          required(:quantity).filled(:int?, gteq?: 0)
          required(:price).filled(:int?, gt?: 0)
        end
      end
    end
  end
end
