# frozen_string_literal: true

module Customer
  module ReadModels
    class OrderedProductLine < ::Domain::SchemaStruct
      attribute :order_line_id, T::Int
      attribute :basket_id, T::Coercible::Int
      attribute :product_id, T::Coercible::Int
      attribute :added_quantity, T::Coercible::Int
    end
  end
end
