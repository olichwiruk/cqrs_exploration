# frozen_string_literal: true

require 'infrastructure/repositories/users_read_model'

class UserUpdatedEventHandler
  def user_updated(event)
    UsersReadModel.update_user(
      event.aggregate_uid,
      event.data
    )
  end
end
