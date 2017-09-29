# frozen_string_literal: true

module Discount
  module Domain
    class Discount < Disposable::Twin
      property :id
      property :name
      property :value
    end
  end
end
