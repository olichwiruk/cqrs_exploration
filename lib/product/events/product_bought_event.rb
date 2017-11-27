# frozen_string_literal: true

module Product
  module Events
    class ProductBoughtEvent < Infrastructure::Event
      attribute :quantity, Infrastructure::Types::Int
    end
  end
end
