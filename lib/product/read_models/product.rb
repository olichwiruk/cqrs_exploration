# frozen_string_literal: true

module Product
  module ReadModels
    class Product < ::Domain::SchemaStruct
      attribute :id, T::Int
      attribute :name, T::String
      attribute :quantity, T::Int
      attribute :price, T::Int
    end
  end
end
