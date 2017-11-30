# frozen_string_literal: true

module Customer
  module Domain
    class User < ROM::Struct
      include Infrastructure::Entity
      constructor_type :schema

      attribute :id, Infrastructure::Types::Coercible::Int
      attribute :uuid, Infrastructure::Types::String
      attribute :name, Infrastructure::Types::String
      attribute :email, Infrastructure::Types::Email

      def self.initialize(name:, email:)
        user = new
        user.apply_event(
          Customer::Events::UserCreatedEvent.new(
            name: name,
            email: email
          )
        )
        user
      end

      def update(name:, email:)
        apply_event(
          Customer::Events::UserUpdatedEvent.new(
            aggregate_uuid: uuid,
            name: name,
            email: email
          )
        )
        self
      end

      def on_user_created(event)
        @uuid = event.aggregate_uuid
        @name = event.name
        @email = event.email
      end

      def on_user_updated(event)
        @name = event.name
        @email = event.email
      end
    end
  end
end
