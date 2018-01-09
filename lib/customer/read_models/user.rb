# frozen_string_literal: true

module Customer
  module ReadModels
    class User < Dry::Struct
      constructor_type :schema
      T = Infrastructure::Types

      attribute :id, T::Int
      attribute :name, T::String
      attribute :email, T::String
    end
  end
end
