# frozen_string_literal: true

require 'customer/domain/basket'

module Customer
  module Repositories
    class BasketRepo < ROM::Repository[:baskets]
      commands :create
      struct_namespace Customer::Domain

      def by_user_id(user_id)
        b = baskets.where(user_id: user_id).one || Customer::Domain::NullBasket.new

        return b if b.nil?
        baskets.combine(:ordered_product_lines).by_pk(b.id).one!
      end

      def save(basket)
        baskets.by_pk(basket.id).command(:update).call(basket)

        ordered_product_lines.where(basket_id: basket.id).command(:delete).call
        ordered_product_lines.command(:create).call(basket.ordered_product_lines)
      end

      def find_or_create(user_id)
        b = by_user_id(user_id)
        return b unless b.nil?

        baskets.command(:create).call(user_id: user_id)
      end
    end
  end
end
