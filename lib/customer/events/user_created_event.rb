# frozen_string_literal: true

module Customer
  module Events
    class UserCreatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_uuid, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::Email

      def values
        instance_values.without('aggregate_uuid', 'aggregate_type')
      end
    end
  end
end
