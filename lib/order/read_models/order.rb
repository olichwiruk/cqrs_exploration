# frozen_string_literal: true

module Order
  module ReadModels
    class Order < Dry::Struct
      include Infrastructure::Types
      constructor_type :schema

      attribute :user_id, Infrastructure::Types::Int
      attribute :discount, Infrastructure::Types::Int
    end
  end
end
