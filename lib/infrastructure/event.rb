require 'infrastructure/types'

class Event < Dry::Struct
  include Types

  attribute :aggregate_uid, Types::String
  attribute :name, Types::String
  attribute :data, Types::String
end
