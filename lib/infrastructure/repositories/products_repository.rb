# frozen_string_literal: true

module Infrastructure
  module Repositories
    class ProductsRepository
      extend Infrastructure::Repositories::Repository
      @bounded_context = 'Product'
    end
  end
end
