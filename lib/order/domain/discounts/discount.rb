# frozen_string_literal: true

module Order
  module Domain
    module Discounts
      class Discount < Disposable::Twin
        property :id
        property :name
        property :value
        property :applicable?, virtual: true
      end
    end
  end
end
