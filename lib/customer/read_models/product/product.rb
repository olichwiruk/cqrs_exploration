# frozen_string_literal: true

module Customer
  module ReadModels
    module Product
      class Product < ::Domain::SchemaStruct
        attribute :id, T::Int
        attribute :name, T::String
        attribute :quantity, T::Int
        attribute :price, T::Int
      end
    end
  end
end
