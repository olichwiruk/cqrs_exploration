# frozen_string_literal: true

module Customer
  module Domain
    class Discount
      attr_reader :aggregate_uid
      attr_reader :value

      class << self
        include Infrastructure::Entity

        def apply_discount(aggregate_uid:, value:); end
      end
    end
  end
end
