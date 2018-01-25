# frozen_string_literal: true

module Order
  module Events
    module Integration
      class OrderCheckedOutIntegrationEvent < Dry::Struct
        T = Infrastructure::Types

        attribute :order_uuid, T::String
      end
    end
  end
end
