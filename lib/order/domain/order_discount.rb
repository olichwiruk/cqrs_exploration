# frozen_string_literal: true

module Order
  module Domain
    class OrderDiscount < ::Domain::SchemaStruct
      attribute :id, T::Int
      attribute :order_id, T::Coercible::Int
      attribute :discount_id, T::Coercible::Int
    end
  end
end
