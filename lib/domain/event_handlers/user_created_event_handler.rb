# frozen_string_literal: true

require 'infrastructure/repositories/users_read_model'

class UserCreatedEventHandler
  def user_created(event)
    UsersReadModel.add_user(
      event.aggregate_uid,
      User.new(
        name: event[:data]['name'],
        email: event[:data]['email']
      )
    )
  end
end
