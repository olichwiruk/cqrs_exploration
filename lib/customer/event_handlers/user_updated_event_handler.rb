# frozen_string_literal: true

require 'infrastructure/repositories/users_repository'

module Customer
  module EventHandlers
    class UserUpdatedEventHandler
      def user_updated(event)
        Infrastructure::Repositories::UsersRepository.update_user(
          event.aggregate_uid,
          event.data
        )
      end
    end
  end
end
