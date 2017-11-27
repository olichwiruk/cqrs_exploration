# frozen_string_literal: true

module Customer
  module Events
    class UserUpdatedEvent < Infrastructure::Event
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::Email
    end
  end
end
