# frozen_string_literal: true

class UsersListViewModel
  attr_reader :users, :current_user_id

  def initialize(users:, current_user_id:)
    @users = users
    @current_user_id = current_user_id
  end
end
