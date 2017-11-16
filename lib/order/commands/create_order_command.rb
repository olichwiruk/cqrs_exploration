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
        @uuid = SecureRandom.uuid
      end

      def validate
        Validator.call(params)
      end
    end
  end
end
