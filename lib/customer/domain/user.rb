# frozen_string_literal: true

require 'infrastructure/entity'
require 'customer/events/user_created_event'
require 'customer/events/user_updated_event'
require 'securerandom'

module Customer
  module Domain
    class User
      attr_reader :id
      attr_reader :uid
      attr_reader :name
      attr_reader :email

      class << self
        include Infrastructure::Entity

        def create_new_user(user_params)
          name = user_params['name']
          email = user_params['email']
          apply_event(
            Customer::Events::UserCreatedEvent.new(
              aggregate_uid: SecureRandom.uuid,
              name: name,
              email: email
            )
          )
          self
        end

        def update_user(user_params)
          uid = user_params['uid']
          name = user_params['name']
          email = user_params['email']
          apply_event(
            Customer::Events::UserUpdatedEvent.new(
              aggregate_uid: uid,
              name: name,
              email: email
            )
          )
          self
        end

        def on_user_created(event)
          @uid = event.aggregate_uid
        end

        def on_user_updated(event); end
      end
    end
  end
end
