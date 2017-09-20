# frozen_string_literal: true

module Product
  module ReadModels
    class Product < Dry::Struct
      include Infrastructure::Types
      constructor_type :symbolized

      attribute :id, Infrastructure::Types::Int
      attribute :name, Infrastructure::Types::String
      attribute :quantity, Infrastructure::Types::Int
      attribute :price, Infrastructure::Types::Int
    end
  end
end
