# frozen_string_literal: true

module Order
  module Events
    class DiscountsAppliedEvent < Infrastructure::Event
      attribute :discounts, Infrastructure::Types::Hash
    end
  end
end
