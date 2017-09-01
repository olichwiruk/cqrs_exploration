# frozen_string_literal: true

Dir["#{Rails.root}/lib/customer/command_handlers/*.rb"].each do |file|
  require file
end
Dir["#{Rails.root}/lib/order/command_handlers/*.rb"].each do |file|
  require file
end

module Infrastructure
  class CommandBus
    class << self
      def send(command)
        bus = {
          'Customer::Commands::CreateUserCommand' =>
            'Customer::CommandHandlers::CreateUserCommandHandler',
          'Customer::Commands::UpdateUserCommand' =>
            'Customer::CommandHandlers::UpdateUserCommandHandler',
          'Order::Commands::ApplyCouponCommand' =>
            'Order::CommandHandlers::ApplyCouponCommandHandler'
        }

        handler = bus.fetch(command.class.to_s).constantize
        handler.execute(command)
      end
    end
  end
end
