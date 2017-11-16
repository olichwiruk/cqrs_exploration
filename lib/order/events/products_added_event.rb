# frozen_string_literal: true

module Order
  module Events
    class ProductsAddedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_uuid, Infrastructure::Types::String
      attribute :products, Infrastructure::Types::Hash

      def values
        formatted_products = products.map do |product|
          {
            id: product.id,
            quantity: product.quantity,
            price: product.price
          }
        end
        instance_values
          .without('aggregate_uuid', 'aggregate_type', 'products')
          .merge(products: formatted_products)
      end
    end
  end
end
