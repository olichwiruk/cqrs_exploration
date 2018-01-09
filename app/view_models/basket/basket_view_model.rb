# frozen_string_literal: true

module Basket
  class BasketViewModel
    attr_reader :draft_order, :errors, :csrf_token

    def initialize(
      draft_order:,
      errors: {},
      csrf_token:
    )
      @errors = errors
      @csrf_token = csrf_token
      @draft_order = draft_order
    end

    def basket_empty?
      draft_order.products.empty?
    end

    def errors?
      !errors.empty?
    end
  end
end
