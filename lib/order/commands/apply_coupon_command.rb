# frozen_string_literal: true

module Order
  module Commands
    class ApplyCouponCommand
      attr_reader :params

      Validator = Dry::Validation.Schema do
        required(:aggregate_id).filled
        required(:value).filled(:int?, gt?: 0, lteq?: 100)
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
