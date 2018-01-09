# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class Discount < Dry::Struct
        T = Infrastructure::Types

        attribute :id, T::Int
        attribute :value, T::Int
        attribute :applicable, T::Bool
      end
    end
  end
end
