class CreateUserCommandHandler

  class << self
    def execute(command)
      User.create_new_user(command.user)
    end
  end

end
