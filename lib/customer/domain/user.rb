# frozen_string_literal: true

module Customer
  module Domain
    class User < ::Domain::SchemaStruct
      include ::Domain::Entity

      attribute :id, T::Coercible::Int
      attribute :uuid, T::String
      attribute :name, T::String
      attribute :email, T::Email
      attribute :loyalty_card, T.Instance(LoyaltyCard)

      def self.initialize(name:, email:)
        user = new
        user.apply_event(
          Customer::Events::UserCreatedEvent.new(
            aggregate_uuid: SecureRandom.uuid,
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

      def give_loyalty_card
        unless loyalty_card?
          @loyalty_card = Domain::LoyaltyCard.new(
            user_id: id,
            discount: 1
          )
        end
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

      # @api private
      def loyalty_card?
        !loyalty_card.nil?
      end
    end
  end
end
