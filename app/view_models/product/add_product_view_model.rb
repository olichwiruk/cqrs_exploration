# frozen_string_literal: true

module Product
  class AddProductViewModel
    attr_reader :product, :csrf_token, :errors

    def initialize(product:, csrf_token:, errors: {})
      @product = product
      @csrf_token = csrf_token
      @errors = errors
    end

    def update(options)
      self.class.new(options)
    end
  end
end
