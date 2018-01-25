# frozen_string_literal: true

module Order
  module Events
    module Integration
      class OrderUpdatedIntegrationEvent < Dry::Struct
        T = Infrastructure::Types

        attribute :order_uuid, T::String
        attribute :total_price, T::Int
        attribute :discount, T::Int
      end
    end
  end
end
