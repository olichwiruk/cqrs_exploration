require 'infrastructure/types'

class Event < Dry::Struct
  include Types

  attribute :name, Types::String
  attribute :data, Types::String
end
