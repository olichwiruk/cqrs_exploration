# frozen_string_literal: true

module Basket
  class BasketViewModel
    attr_reader :products, :basket, :errors, :csrf_token

    def initialize(
      products:,
      basket:,
      errors: {},
      csrf_token:
    )
      @products = products
      @basket = basket
      @errors = errors
      @csrf_token = csrf_token
    end
  end
end
