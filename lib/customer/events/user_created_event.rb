# frozen_string_literal: true

module Customer
  module Events
    class UserCreatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_id, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::Email

      def values
        instance_values.without('aggregate_id', 'aggregate_type')
      end
    end
  end
end
