# frozen_string_literal: true

module Order
  module Events
    class DiscountsAppliedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_uuid, Infrastructure::Types::String
      attribute :discounts, Infrastructure::Types::Hash

      def values
        instance_values.without('aggregate_uuid', 'aggregate_type')
      end
    end
  end
end
