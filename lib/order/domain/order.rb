# frozen_string_literal: true

module Order
  module Domain
    class Order
      class << self
        include Infrastructure::Entity
      end
    end
  end
end
