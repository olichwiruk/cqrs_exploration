# frozen_string_literal: true

module Order
  module Commands
    class AddProductsCommand
      attr_reader :params

      Validator = Dry::Validation.Form do
        required(:order_id).filled
        required(:selected_products).each do
          required(:id).filled(:int?)
          required(:added_quantity).filled(:int?, gteq?: 0)
          required(:order_line_id).maybe(:int?, gteq?: 0)
        end
      end

      def initialize(params)
        @params = params
      end

      def validate
        Validator.call(params.to_h)
      end
    end
  end
end
