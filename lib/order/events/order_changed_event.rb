# frozen_string_literal: true

module Order
  module Events
    class OrderChangedEvent < Infrastructure::Event
      attribute :products, T::Hash

      def values
        super.except(:products)
          .merge(products: products.map(&:to_h))
      end
    end
  end
end
