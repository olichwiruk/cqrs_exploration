# frozen_string_literal: true

module Customer
  module Events
    class DiscountAppliedEvent < Dry::Struct
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
