# frozen_string_literal: true

module Order
  module Events
    class OrderCreatedEvent < Infrastructure::Event
      attribute :user_id, Infrastructure::Types::String
    end
  end
end
