# frozen_string_literal: true

require 'infrastructure/types'

module Infrastructure
  class Event < Dry::Struct
    include Infrastructure::Types

    attribute :aggregate_uid, Types::String
    attribute :name, Types::String
    attribute :data, Types::String
  end
end
