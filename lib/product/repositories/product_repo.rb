# frozen_string_literal: true

require 'product/domain/product'

module Product
  module Repositories
    class ProductRepo < ROM::Repository[:products]
      commands :create, delete: :by_pk
      struct_namespace Product::Domain

      def by_id(id)
        products.where(id: id).one!
      end

      def by_ids(ids)
        products.by_pk(ids).to_a
      end

      def all_products
        products.to_a
      end

      def save(product)
        return create(product) if product.id.nil?
        products.by_pk(product.id).command(:update).call(product)
      end

      def available_quantity?(id, q)
        !products.where(id: id) { quantity >= (q || 0) }.count.zero?
      end
    end
  end
end
