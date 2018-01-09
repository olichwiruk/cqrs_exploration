# frozen_string_literal: true

module Product
  class ProductsListViewModel
    attr_reader :csrf_token, :errors, :draft_order

    def initialize(draft_order:, csrf_token:, errors: {})
      @csrf_token = csrf_token
      @errors = errors
      @draft_order = draft_order
    end

    def logged?
      draft_order.user_id
    end

    def products_added?
      !draft_order.products.empty?
    end
  end
end
