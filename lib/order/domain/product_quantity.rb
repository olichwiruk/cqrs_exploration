# frozen_string_literal: true

module Order
  module Domain
    class ProductQuantity < Dry::Struct
      include Infrastructure::Types

      attribute :id, Infrastructure::Types::Int
      attribute :price, Infrastructure::Types::Int
      attribute :quantity, Infrastructure::Types::Int
    end
  end
end
