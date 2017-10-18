# frozen_string_literal: true

module Customer
  module Events
    class UserUpdatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_uuid, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String.optional
      attribute :email, Infrastructure::Types::Email.optional

      def values
        instance_values
          .without('aggregate_uuid', 'aggregate_type')
          .delete_if do |_, v|
          v.nil?
        end
      end
    end
  end
end
