# frozen_string_literal: true

module Order
  module Commands
    class ApplyDiscountsCommand
      attr_reader :params

      Validator = Dry::Validation.Schema do
        required(:aggregate_uuid).filled
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
