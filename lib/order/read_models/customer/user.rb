# frozen_string_literal: true

module Order
  module ReadModels
    module Customer
      class User < ::Domain::SchemaStruct
        attribute :id, T::Coercible::Int
        attribute :uuid, T::String
        attribute :name, T::String
        attribute :email, T::Email
        attribute :loyalty_card, T.Instance(LoyaltyCard)
      end
    end
  end
end
