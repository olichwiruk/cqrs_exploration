# frozen_string_literal: true

module User
  class UserLoginViewModel
    attr_reader :users, :csrf_token

    def initialize(users:, csrf_token:)
      @users = users
      @csrf_token = csrf_token
    end
  end
end
