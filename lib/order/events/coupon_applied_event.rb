# frozen_string_literal: true

module Order
  module Events
    class CouponAppliedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_uid, Infrastructure::Types::String
      attribute :value, Infrastructure::Types::Int

      def values
        val = instance_values
        val.delete('aggregate_uid')
        val
      end
    end
  end
end
