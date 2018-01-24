# frozen_string_literal: true

module Order
  module ReadModels
    module Customer
      class NullBasket < ::Domain::SchemaStruct
        attribute :ordered_product_lines, T.Array(OrderedProductLine).default([])
        attribute :discount, T::Coercible::Int.default(0)
        attribute :total_price, T::Coercible::Int.default(0)
        attribute :final_price, T::Coercible::Int.default(0)
      end
    end
  end
end
