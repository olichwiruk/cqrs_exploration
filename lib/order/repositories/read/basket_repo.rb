# frozen_string_literal: true

module Order
  module Repositories
    module Read
      class BasketRepo < ROM::Repository[:baskets]
        struct_namespace Order::ReadModels::Customer

        def by_user_id(user_id)
          baskets.combine(:ordered_product_lines).where(user_id: user_id).one || Order::ReadModels::Customer::NullBasket.new
        end
      end
    end
  end
end

