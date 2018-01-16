# frozen_string_literal: true

module Infrastructure
  class CommandBus
    @bus = {}

    class << self
      def send(command)
        handler = @bus.fetch(command.class.to_s).call
        handler.execute(command)
      end

      def register(container)
        register_handler('Order::Commands::CreateOrderCommand') do
          container['order.commands.create_order_command_handler']
        end

        register_handler('Order::Commands::ApplyDiscountsCommand') do
          container['order.commands.apply_discounts_command_handler']
        end

        register_handler('Order::Commands::AddProductsCommand') do
          container['order.commands.add_products_command_handler']
        end

        register_handler('Order::Commands::ChangeOrderCommand') do
          container['order.commands.change_order_command_handler']
        end

        register_handler('Order::Commands::CheckoutOrderCommand') do
          container['order.commands.checkout_order_command_handler']
        end

        @bus.freeze
      end

      # @api private
      def register_handler(name, &block)
        @bus[name] = block
      end
    end
  end
end
