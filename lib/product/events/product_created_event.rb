# frozen_string_literal: true

module Product
  module Events
    class ProductCreatedEvent < Infrastructure::Event
      attribute :name, Infrastructure::Types::String
      attribute :quantity, Infrastructure::Types::Int
      attribute :price, Infrastructure::Types::Int
    end
  end
end
