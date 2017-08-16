Dir["#{File.dirname(__FILE__)}/command_handlers/*.rb"].each do |file|
  require file
end
#todo lib container


class CommandBus

  class << self

    def send(command)
      bus = {
        'CreateUserCommand' => 'CreateUserCommandHandler'
      }

      handler = bus.fetch(command.class.to_s).constantize
      handler.execute(command)
    end

  end
end
