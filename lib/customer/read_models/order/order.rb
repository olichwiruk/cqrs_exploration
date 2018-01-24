# frozen_string_literal: true

module Customer
  module ReadModels
    module Order
      class Order < ::Domain::SchemaStruct
        attribute :id, T::Coercible::Int
        attribute :uuid, T::String
        attribute :user_id, T::Coercible::Int
        attribute :completed, T::Bool
        attribute :order_lines, T::Array
        attribute :discounts, T::Array
      end
    end
  end
end
