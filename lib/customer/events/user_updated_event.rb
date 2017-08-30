# frozen_string_literal: true

require 'infrastructure/types'

module Customer
  module Events
    class UserUpdatedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_uid, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::String

      def values
        val = instance_values
        val.delete('aggregate_uid')
        val.delete_if { |_, v| v.nil? }
        val
      end
    end
  end
end
