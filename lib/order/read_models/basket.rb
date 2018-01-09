# frozen_string_literal: true

module Order
  module ReadModels
    class Basket < Dry::Struct
      constructor_type :schema
      T = Infrastructure::Types

      attribute :user_id, T::Int
      attribute :products, T::Hash
      attribute :discount, T::Int
      attribute :total_price, T::Int
    end
  end
end
