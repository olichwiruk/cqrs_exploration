# frozen_string_literal: true

class UserRegistrationViewModel
  attr_reader :user, :csrf_token, :errors

  def initialize(user:, csrf_token:, errors: {})
    @user = user
    @csrf_token = csrf_token
    @errors = errors
  end
end
