# frozen_string_literal: true

module Basket
  class BasketViewModel
    attr_reader :order_id, :products, :discount, :total, :errors, :csrf_token

    def initialize(order_id:, products:, discount:, total:, errors: {}, csrf_token:)
      @order_id = order_id
      @products = products
      @discount = discount
      @total = total
      @errors = errors
      @csrf_token = csrf_token
    end
  end
end
