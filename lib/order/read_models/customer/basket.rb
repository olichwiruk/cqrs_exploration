# frozen_string_literal: true

module Order
  module ReadModels
    module Customer
      class Basket < ::Domain::SchemaStruct
        attribute :id, T::Int
        attribute :user_id, T::Coercible::Int
        attribute :ordered_product_lines, T.Array(OrderedProductLine)
        attribute :discount, T::Coercible::Int
        attribute :total_price, T::Coercible::Float
        attribute :final_price, T::Coercible::Float
      end
    end
  end
end
