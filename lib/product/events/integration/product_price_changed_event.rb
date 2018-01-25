# frozen_string_literal: true

module Product
  module Events
    module Integration
      class ProductPriceChangedEvent < Dry::Struct
        T = Infrastructure::Types

        attribute :product_id, T::Int
      end
    end
  end
end
