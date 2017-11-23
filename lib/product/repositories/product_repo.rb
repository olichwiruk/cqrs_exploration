# frozen_string_literal: true
module Product
  module Repositories
    class ProductRepo < ROM::Repository[:products]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        products.where(id: id).one!
      end
    end
  end
end
