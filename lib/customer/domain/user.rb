# frozen_string_literal: true

require 'securerandom'

module Customer
  module Domain
    class User < Disposable::Twin
      include Infrastructure::Entity
      feature Changed

      property :id
      property :uuid
      property :name
      property :email

      def create
        apply_event(
          Customer::Events::UserCreatedEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_id: SecureRandom.uuid,
            name: name,
            email: email
          )
        )
        self
      end

      def update(user_params)
        new_name = user_params['name']
        new_email = user_params['email']
        event = Customer::Events::UserUpdatedEvent.new(
          aggregate_type: self.class.to_s.split('::').last.downcase,
          aggregate_id: uuid,
          name: update_attr(name, new_name),
          email: update_attr(email, new_email)
        )
        apply_event(event) unless event.values.empty?
        self
      end

      def on_user_created(event)
        self.uuid = event.aggregate_id
      end

      def on_user_updated(event)
        update_from_hash(event.values)
      end

      # @api private
      def update_attr(attr, new_attr)
        attr.eql?(new_attr) ? nil : new_attr
      end
    end
  end
end
