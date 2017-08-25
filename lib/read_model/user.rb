# frozen_string_literal: true

require 'domain/domain/entity'
require 'domain/events/user_created_event'
require 'securerandom'

module ReadModel
  class User < Disposable::Twin
    property :id
    property :name
    property :email

    class << self
      include Entity

      def create_new_user(user_params)
        name = user_params['name']
        email = user_params['email']
        apply_event(UserCreatedEvent.new(aggregate_uid:
                                         SecureRandom.uuid,
                                         name: name,
                                         email: email))
        self
      end

      def on_user_created(event)
        @uid = event.aggregate_uid
      end
    end
  end
end
