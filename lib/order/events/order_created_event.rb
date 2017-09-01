# frozen_string_literal: true

module Order
  module Events
    class OrderCreatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_uid, Infrastructure::Types::String
      attribute :user_uid, Infrastructure::Types::String
      attribute :discount, Infrastructure::Types::Int

      def values
        val = instance_values
        val.delete('aggregate_uid')
        val.delete('discount')
        val
      end
    end
  end
end
