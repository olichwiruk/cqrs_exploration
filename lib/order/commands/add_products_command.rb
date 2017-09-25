# frozen_string_literal: true

module Order
  module Commands
    class AddProductsCommand
      attr_reader :params

      Validator = Dry::Validation.Schema do
        required(:order_id).filled
        required(:basket).filled(:hash?)
      end

      def initialize(params)
        @params = params
      end

      def validate
        Validator.call(params)
      end
    end
  end
end
