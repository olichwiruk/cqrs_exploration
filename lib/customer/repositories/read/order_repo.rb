# frozen_string_literal: true

module Customer
  module Repositories
    module Read
      class OrderRepo < ROM::Repository[:orders]
        struct_namespace Customer::ReadModels::Order

        def by_uuid(uuid)
          orders.combine(:order_lines).where(uuid: uuid).one!
        end
      end
    end
  end
end
