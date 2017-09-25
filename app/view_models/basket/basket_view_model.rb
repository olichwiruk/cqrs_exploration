# frozen_string_literal: true

module Basket
  class BasketViewModel
    attr_reader :products, :discount, :total, :csrf_token

    def initialize(products:, discount:, total:, csrf_token:)
      @products = products
      @discount = discount
      @total = total
      @csrf_token = csrf_token
    end
  end
end
