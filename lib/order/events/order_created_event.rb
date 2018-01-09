# frozen_string_literal: true

module Order
  module Events
    class OrderCreatedEvent < Infrastructure::Event
      attribute :user_id, T::String
    end
  end
end
