require 'infrastructure/write_repo'
require 'infrastructure/event'

class CreateUserCommandHandler
  class << self
    def execute(command)
      user = command.user
      data = "name: #{user.name}, email: #{user.email}"
      WriteRepo::add_event(Event.new(name: 'create user',
                                     data: data))
    end
  end
end
