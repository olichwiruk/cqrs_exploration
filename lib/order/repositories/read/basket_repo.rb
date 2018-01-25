# frozen_string_literal: true

module Order
  module Repositories
    module Read
      class BasketRepo < ROM::Repository[:baskets]
        struct_namespace Order::ReadModels::Customer

        def by_user_id(id)
          null_basket = Order::ReadModels::Customer::NullBasket.new
          baskets.combine(:ordered_product_lines).where(user_id: id).one || null_basket
        end
      end
    end
  end
end
