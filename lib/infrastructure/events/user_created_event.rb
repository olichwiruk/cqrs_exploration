class UserCreatedEvent < Dry::Struct
  include Types

  attribute :aggregate_id, Types::Integer
  attribute :name, Types::String
  attribute :email, Types::Email

end
