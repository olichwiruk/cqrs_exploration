# frozen_string_literal: true

module Order
  module Events
    class OrderChangedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_id, Infrastructure::Types::String
      attribute :products, Infrastructure::Types::Hash

      def values
        instance_values.without('aggregate_id', 'aggregate_type')
      end
    end
  end
end
