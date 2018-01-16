# frozen_string_literal: true

module Customer
  module Repositories
    module Read
      class ProductRepo < ROM::Repository[:products]
        def by_ids(ids)
          products.by_pk(ids).to_a
        end
      end
    end
  end
end
