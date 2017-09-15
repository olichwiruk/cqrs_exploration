# frozen_string_literal: true

module Products
  class ProductsListViewModel
    attr_reader :products, :current_user_id

    def initialize(products:, current_user_id:)
      @products = products
      @current_user_id = current_user_id
    end
  end
end
