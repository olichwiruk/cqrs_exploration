# frozen_string_literal: true

module Product
  class ProductsListViewModel
    attr_reader :products, :basket_hash, :current_user_id, :csrf_token, :errors

    def initialize(products:, basket_hash: {}, current_user_id:, csrf_token:, errors: {})
      @products = products
      @basket_hash = basket_hash
      @current_user_id = current_user_id
      @csrf_token = csrf_token
      @errors = errors
    end
  end
end
