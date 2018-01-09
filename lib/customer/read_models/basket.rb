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

      # def discount_service
      #   MyApp.instance.container['services.discount_service']
      # end

      # def pricing_service
      #   MyApp.instance.container['services.pricing_service']
      # end

      def recalculate(products_quantity)

        @final_price = total_price * (1 - discount / 100.0)
        self.class.new(
          to_h.merge(
            total_price: pricing_service.calculate_total(products_quantity),
            discount: discount_service.sum_applicable_discounts(user_id)
          )
        )
      end

      def update(ordered_product_lines, summary)
        self.class.new(
          to_h.merge(ordered_product_lines: ordered_product_lines)
        )
      end

      def restart
        @ordered_product_lines = []
        @discount = 0
        @total_price = 0
        @final_price = 0
        self
      end
    end
  end
end
