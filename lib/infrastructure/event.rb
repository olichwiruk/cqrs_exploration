# frozen_string_literal: true

require 'infrastructure/types'

module Infrastructure
  class Event < Dry::Struct
    include Infrastructure::Types
    constructor_type :schema

    attribute :aggregate_type, Types::String
    attribute :aggregate_uuid, Types::String.default(SecureRandom.uuid)

    def values
      instance_values.without(*%w(aggregate_uuid aggregate_type))
    end
  end
end
