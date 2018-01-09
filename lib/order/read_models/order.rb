# frozen_string_literal: true

module Order
  module ReadModels
    class Order < Dry::Struct
      constructor_type :schema
      T = Infrastructure::Types

      attribute :user_id, T::Int
      attribute :discount, T::Int
    end
  end
end
