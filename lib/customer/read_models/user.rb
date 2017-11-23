# frozen_string_literal: true

module Customer
  module ReadModels
    class User < Dry::Struct
      include Infrastructure::Types
      constructor_type :schema

      attribute :id, Infrastructure::Types::Int
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::String
    end
  end
end
