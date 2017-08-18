class CreateUserCommandHandler

  class << self
    def execute(command)
      user = User.create_new_user(command.user)
      user.commit
    end
  end
end
