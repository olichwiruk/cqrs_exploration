# frozen_string_literal: true

require 'customer/read_models/basket'

module Order
  module Repositories
    module Read
      class BasketRepo < ROM::Repository[:baskets]
        struct_namespace ::Customer::ReadModels

        def by_user_id(user_id)
          b = baskets.where(user_id: user_id).one || ::Customer::ReadModels::NullBasket.new

          return b if b.nil?
          baskets.combine(:ordered_product_lines).by_pk(b.id).one!
        end
      end
    end
  end
end

