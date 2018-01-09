# frozen_string_literal: true

module Customer
  module Domain
    class LoyaltyCard < ::Domain::SchemaStruct
      attribute :id, T::Coercible::Int
      attribute :user_id, T::Coercible::Int
      attribute :discount, T::Int
    end
  end
end
