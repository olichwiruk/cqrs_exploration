# frozen_string_literal: true

require 'product/domain/product'

module Product
  module Repositories
    class ProductRepo < ROM::Repository[:products]
      commands :create, update: :by_pk, delete: :by_pk
      struct_namespace Product::Domain

      def by_id(id)
        products.where(id: id).one!
      end
    end
  end
end
