module Types
  include Dry::Types.module

  Email = String.constrained(format:
                /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
end

class User < ActiveRecord::Base
  include Types

  attribute :name, Types::String
  attribute :email, Types::Email
end
