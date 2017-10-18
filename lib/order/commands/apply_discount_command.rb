# frozen_string_literal: true

module Order
  module Commands
    class ApplyDiscountCommand
      attr_reader :params

      Validator = Dry::Validation.Schema do
        required(:aggregate_uuid).filled
        required(:discount_id).filled
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
