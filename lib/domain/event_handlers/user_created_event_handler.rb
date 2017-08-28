# frozen_string_literal: true

require 'infrastructure/repositories/users_read_model'

class UserCreatedEventHandler
  def user_created(event)
    UsersReadModel.add_user(
      event.aggregate_uid,
      event.data
    )
  end
end
