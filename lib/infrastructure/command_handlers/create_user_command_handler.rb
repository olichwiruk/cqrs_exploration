class CreateUserCommandHandler

  class << self
    def execute(command)
      validate(command.user)
      user = User.create_new_user(command.user)
      user.commit
    end
  end
end
