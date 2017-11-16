# frozen_string_literal: true

module Infrastructure
  class CommandBus
    @bus = {
      'Order::Commands::CreateOrderCommand' =>
        'Order::CommandHandlers::CreateOrderCommandHandler',
      'Order::Commands::ApplyDiscountsCommand' =>
        'Order::CommandHandlers::ApplyDiscountsCommandHandler',
      'Order::Commands::AddProductsCommand' =>
        'Order::CommandHandlers::AddProductsCommandHandler',
      'Order::Commands::ChangeOrderCommand' =>
        'Order::CommandHandlers::ChangeOrderCommandHandler',
      'Order::Commands::CheckoutOrderCommand' =>
        'Order::CommandHandlers::CheckoutOrderCommandHandler'
    }

    def self.send(command)
      handler = @bus.fetch(command.class.to_s).constantize
      handler.execute(command)
    end
  end
end
