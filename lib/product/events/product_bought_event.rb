# frozen_string_literal: true

module Product
  module Events
    class ProductBoughtEvent < Infrastructure::Event
      attribute :quantity, T::Int
    end
  end
end
