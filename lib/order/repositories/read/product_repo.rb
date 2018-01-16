# frozen_string_literal: true

module Order
  module Repositories
    module Read
      class ProductRepo < ROM::Repository[:products]
        def by_ids(ids)
          products.by_pk(ids).to_a
        end

        def all_products
          products.to_a
        end

        def available_quantity?(id, q)
          !products.where(id: id) { quantity >= (q || 0) }.count.zero?
        end
      end
    end
  end
end
