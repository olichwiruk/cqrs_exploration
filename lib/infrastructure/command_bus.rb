# frozen_string_literal: true

module Infrastructure
  class CommandBus
    @bus = {
      'Order::Commands::CreateOrderCommand' =>
        'Order::CommandHandlers::CreateOrderCommandHandler',
      'Order::Commands::ApplyCouponCommand' =>
        'Order::CommandHandlers::ApplyCouponCommandHandler',
      'Order::Commands::AddProductsCommand' =>
        'Order::CommandHandlers::AddProductsCommandHandler',
      'Order::Commands::ChangeOrderCommand' =>
        'Order::CommandHandlers::ChangeOrderCommandHandler'
    }

    def self.send(command)
      handler = @bus.fetch(command.class.to_s).constantize
      handler.execute(command)
    end
  end
end
