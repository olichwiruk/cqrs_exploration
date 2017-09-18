# frozen_string_literal: true

module Order
  module Domain
    class Coupon
      attr_reader :value

      def initialize(value:)
        @value = value
      end
    end
  end
end
