# frozen_string_literal: true

require 'securerandom'

module Order
  module Commands
    class CreateOrderCommand
      attr_reader :params
      attr_reader :uuid

      Validator = Dry::Validation.Schema do
        required(:user_id).filled
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
