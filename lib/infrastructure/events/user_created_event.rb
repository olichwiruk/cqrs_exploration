class UserCreatedEvent < Dry::Struct
  include Types

  attribute :name, Types::String
  attribute :email, Types::Email

end
