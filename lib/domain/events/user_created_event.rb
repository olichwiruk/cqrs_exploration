require 'infrastructure/types'

class UserCreatedEvent < Dry::Struct
  include Types

  attribute :aggregate_uid, Types::String
  attribute :name, Types::String
  attribute :email, Types::Email

  def values
    val = instance_values
    val.delete('aggregate_uid')
    val
  end
end
