# frozen_string_literal: true

module Order
  module Events
    class OrderCreatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_id, Infrastructure::Types::String
      attribute :user_id, Infrastructure::Types::String
      attribute :discount_id, Infrastructure::Types::Int

      def values
        instance_values.without('aggregate_id', 'aggregate_type', 'discount_id')
      end
    end
  end
end
