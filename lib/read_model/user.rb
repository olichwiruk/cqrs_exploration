# frozen_string_literal: true

require 'domain/domain/entity'
require 'domain/events/user_created_event'
require 'domain/events/user_updated_event'
require 'securerandom'

module ReadModel
  class User < Disposable::Twin
    feature Changed

    property :id
    property :uid
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

      def update_user(user_params)
        uid = user_params['uid']
        name = user_params['name']
        email = user_params['email']
        apply_event(UserUpdatedEvent.new(aggregate_uid: uid,
                                         name: name,
                                         email: email))
        self
      end

      def on_user_created(event)
        @uid = event.aggregate_uid
      end

      def on_user_updated(event); end
    end
  end
end
