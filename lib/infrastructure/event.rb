# frozen_string_literal: true

module Infrastructure
  class Event < Dry::Struct
    T = Infrastructure::Types

    attribute :aggregate_uuid, T::String

    def values
      to_hash.except(:aggregate_uuid)
    end
  end
end
