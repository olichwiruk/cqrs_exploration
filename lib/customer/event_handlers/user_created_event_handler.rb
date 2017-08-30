# frozen_string_literal: true

require 'infrastructure/repositories/users_repository'

module Customer
  module EventHandlers
    class UserCreatedEventHandler
      def user_created(event)
        Infrastructure::Repositories::UsersRepository.add_user(
          event.aggregate_uid,
          event.data
        )

        command = Customer::Commands::ApplyDiscountCommand.new(
          aggregate_uid: event.aggregate_uid,
          value: 10
        )
        Infrastructure::CommandBus.send(command)
      end
    end
  end
end
