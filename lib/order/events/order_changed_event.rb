# frozen_string_literal: true

module Order
  module Events
    class OrderChangedEvent < Infrastructure::Event
      attribute :products, Infrastructure::Types::Hash

      def values
        formatted_products = products.map do |product|
          {
            id: product.id,
            quantity: product.quantity,
            price: product.price
          }
        end

        super.without(*%w(products))
          .merge(products: formatted_products)
      end
    end
  end
end
