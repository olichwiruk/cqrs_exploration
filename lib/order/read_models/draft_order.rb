# frozen_string_literal: true

module Order
  module ReadModels
    class DraftOrder < Dry::Struct
      constructor_type :schema
      T = Infrastructure::Types

      attribute :user_id, T::Int
      attribute :discount, T::Int
      attribute :total_price, T::Float
      attribute :final_price, T::Float
      attribute :products, T.Array(Order::ReadModels::OfferedProduct)
    end
  end
end
