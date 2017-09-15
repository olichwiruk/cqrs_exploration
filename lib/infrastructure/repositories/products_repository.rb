# frozen_string_literal: true

module Infrastructure
  module Repositories
    class ProductsRepository
      class << self
        # write
        def save(product)
          Product::Domain::Product.new(
            AR::Product.create!(product.attributes)
          )
        end

        def update(product)
          Product::Domain::Product.new(
            AR::Product.update(product.id, product.attributes)
          )
        end

        # read
        def all_products
          AR::Product.all
        end

        def find(id)
          Product::Domain::Product.new(
            AR::Product.find(id)
          )
        end

        def build(params)
          Product::Domain::Product.new(
            AR::Product.new(params)
          )
        end
      end
    end
  end
end
