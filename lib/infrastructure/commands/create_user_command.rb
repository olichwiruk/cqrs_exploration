class CreateUserCommand
  attr_reader :user

  def initialize(user)
    @user = user
  end
end
