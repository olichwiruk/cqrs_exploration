# frozen_string_literal: true

module Customer
  module Domain
    class User < Disposable::Twin
      include Infrastructure::Entity
      feature Changed

      property :id
      property :uuid
      property :name
      property :email

      def self.initialize(model)
        user = new(model)
        user.apply_event(
          Customer::Events::UserCreatedEvent.new(
            aggregate_type: to_s.split('::').last.downcase,
            aggregate_uuid: user.uuid,
            name: user.name,
            email: user.email
          )
        )
        user
      end

      def update(user_params)
        new_name = user_params['name']
        new_email = user_params['email']
        event = Customer::Events::UserUpdatedEvent.new(
          aggregate_type: self.class.to_s.split('::').last.downcase,
          aggregate_uuid: uuid,
          name: update_attr(name, new_name),
          email: update_attr(email, new_email)
        )
        apply_event(event) unless event.values.empty?
        self
      end

      def on_user_created(event)
        self.uuid = event.aggregate_uuid
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
