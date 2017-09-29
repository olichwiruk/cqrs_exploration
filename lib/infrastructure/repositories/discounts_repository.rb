# frozen_string_literal: true

module Infrastructure
  module Repositories
    class DiscountsRepository
      class << self
        def find(id)
          Discount::Domain::Discount.new(
            AR::Discount.find(id)
          )
        end
      end
    end
  end
end
