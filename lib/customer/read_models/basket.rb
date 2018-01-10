# frozen_string_literal: true

module Customer
  module ReadModels
    class Basket < ::Domain::SchemaStruct
      attribute :id, T::Int
      attribute :user_id, T::Coercible::Int
      attribute :ordered_product_lines, T.Array(ReadModels::OrderedProductLine)
      attribute :discount, T::Coercible::Int
      attribute :total_price, T::Coercible::Float
      attribute :final_price, T::Coercible::Float

      def update(ordered_product_lines, summary)
        self.class.new(
          to_h
          .merge(ordered_product_lines: ordered_product_lines)
          .merge(summary)
        )
      end

      def restart
        self.class.new(
          to_h.merge(
            ordered_product_lines: [],
            discount: 0,
            total_price: 0,
            final_price: 0
          )
        )
      end
    end
  end
end
