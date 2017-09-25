# frozen_string_literal: true

module Infrastructure
  module Repositories
    class ProductsRepository
      extend Infrastructure::Repositories::Repository
      @bounded_context = 'Product'

      class << self
        def available_quantity?(id, quantity)
          quantity.to_i <= AR::Product.find(id).quantity
        end
      end
    end
  end
end
