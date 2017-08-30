# frozen_string_literal: true

require 'infrastructure/types'

module Customer
  module Events
    class UserCreatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_uid, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::Email

      def values
        val = instance_values
        val.delete('aggregate_uid')
        val
      end
    end
  end
end
