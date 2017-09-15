# frozen_string_literal: true

module Order
  module Domain
    class Coupon
      attr_reader :order_uuid
      attr_reader :value

      def initialize(order_uuid:, value:)
        @order_uuid = order_uuid
        @value = value
      end
    end
  end
end
