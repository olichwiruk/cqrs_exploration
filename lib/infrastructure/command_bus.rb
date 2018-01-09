# frozen_string_literal: true

module Infrastructure
  class CommandBus
    @bus = {
      'Order::Commands::CreateOrderCommand' =>
      'create_order_command_handler',
      'Order::Commands::ApplyDiscountsCommand' =>
      'apply_discounts_command_handler',
      'Order::Commands::AddProductsCommand' =>
      'add_products_command_handler',
      'Order::Commands::ChangeOrderCommand' =>
      'change_order_command_handler',
      'Order::Commands::CheckoutOrderCommand' =>
      'checkout_order_command_handler'
    }

    class << self
      def send(command)
        handler = @bus.fetch(command.class.to_s)
        container_wrapper(handler).execute(command)
      end

      def finalize
        @bus.freeze
      end

      # # @api private
      # def container_wrapper(handler)
      #   container["commands.#{handler}"]
      # end

      # # @api private
      # def container
      #   MyApp.instance.container
      # end
    end
  end
end
