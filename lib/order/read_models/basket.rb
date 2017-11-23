# frozen_string_literal: true

module Order
  module ReadModels
    class Basket < Dry::Struct
      include Infrastructure::Types
      constructor_type :schema

      attribute :user_id, Infrastructure::Types::Int
      attribute :products, Infrastructure::Types::Hash
      attribute :discount, Infrastructure::Types::Int
      attribute :total_price, Infrastructure::Types::Int
    end
  end
end
