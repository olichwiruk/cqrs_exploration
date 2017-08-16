require 'infrastructure/write_repo'
require 'infrastructure/event'

class CreateUserCommandHandler
  class << self
    def execute(command)
      user = command.user
      User.create_new_user(user)
    end
  end
end
