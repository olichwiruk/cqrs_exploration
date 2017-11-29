# frozen_string_literal: true

module Customer
  module Domain
    class UserRom < ROM::Struct
      include Infrastructure::Entity

      attr_reader :id, :uuid, :name, :email

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
            aggregate_uuid: @uuid,
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
