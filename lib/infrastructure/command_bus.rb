# frozen_string_literal: true

Dir["#{Rails.root}/lib/domain/command_handlers/*.rb"].each do |file|
  require file
end
# TODO: lib container

class CommandBus
  class << self
    def send(command)
      bus = {
        'CreateUserCommand' => 'CreateUserCommandHandler',
        'UpdateUserCommand' => 'UpdateUserCommandHandler'
      }

      handler = bus.fetch(command.class.to_s).constantize
      handler.execute(command)
    end
  end
end
