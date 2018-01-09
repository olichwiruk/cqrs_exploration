# frozen_string_literal: true

module Product
  module ReadModels
    class OfferedProduct < Dry::Struct
      constructor_type :schema
      T = Infrastructure::Types

      attribute :errors, T::Array
      attribute :id, T::Int
      attribute :name, T::String
      attribute :quantity, T::Int
      attribute :price, T::Int
      attribute :added_quantity, T::Int
      attribute :discount, T::Int
      attribute :order_line_id, T::Int

      def total_price
        price * added_quantity
      end

      def final_price
        total_price * (1 - discount / 100.0)
      end
    end
  end
end
