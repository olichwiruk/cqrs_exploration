# frozen_string_literal: true

module Order
  class Boot
    def self.call(container)
      container.register('order.repositories.orders') do
        Infrastructure::VersionedRepo.new(
          Order::Repositories::OrderRepo.new(
            container['persistence']
          ),
          Infrastructure::EventRepo[:order].new(
            container['persistence']
          )
        )
      end

      container.register('order.repositories.order_process_managers') do
        Order::Repositories::OrderProcessManagerRepo.new(
          container['persistence']
        )
      end

      container.register('order.repositories.discounts') do
        Order::Repositories::DiscountRepo.new(
          container['persistence']
        )
      end

      container.register('order.services.pricing_service') do
        Order::Services::Domain::PricingService.new
      end

      container.register('order.services.discount_service') do
        Order::Services::Domain::DiscountService.new(
          container['order.read_repos.users'],
          container['order.read_repos.products'],
          container['order.repositories.orders'],
          container['order.repositories.discounts'],
          container['order.services.pricing_service']
        )
      end

      container.register('order.generators.draft_order_generator') do
        Order::Generators::DraftOrderGenerator.new(
          container['order.read_repos.products'],
          container['order.repositories.orders'],
          container['order.read_repos.baskets']
        )
      end

      container.register('order.services.add_products_to_order_service') do
        Order::Services::AddProductsToOrderService.new(
          container['order.repositories.orders'],
          container['order.read_repos.products']
        )
      end

      container.register('order.services.change_order_service') do
        Order::Services::ChangeOrderService.new(
          container['order.repositories.orders'],
          container['order.read_repos.products']
        )
      end

      container.register('order.services.checkout_service') do
        Order::Services::CheckoutService.new(
          container['customer.repositories.users'],
          container['order.read_repos.baskets'],
          container['order.repositories.orders']
        )
      end

      container.register('order.commands.create_order_command_handler') do
        Order::CommandHandlers::CreateOrderCommandHandler.new(
          container['order.repositories.orders']
        )
      end

      container.register('order.commands.add_products_command_handler') do
        Order::CommandHandlers::AddProductsCommandHandler.new(
          container['order.repositories.orders']
        )
      end

      container.register('order.commands.change_order_command_handler') do
        Order::CommandHandlers::ChangeOrderCommandHandler.new(
          container['order.repositories.orders']
        )
      end

      container.register('order.commands.checkout_order_command_handler') do
        Order::CommandHandlers::CheckoutOrderCommandHandler.new(
          container['order.repositories.orders']
        )
      end

      container.register('order.commands.apply_discounts_command_handler') do
        Order::CommandHandlers::ApplyDiscountsCommandHandler.new(
          container['order.repositories.orders'],
          container['order.services.discount_service']
        )
      end

      container.register('order.events.order_process_manager_router') do
        Order::ProcessManagers::OrderProcessManagerRouter.new(
          container['order.repositories.order_process_managers']
        )
      end

      container.register('order.read_repos.users') do
        Order::Repositories::Read::UserRepo.new(
          container['persistence']
        )
      end

      container.register('order.read_repos.baskets') do
        Order::Repositories::Read::BasketRepo.new(
          container['persistence']
        )
      end

      container.register('order.read_repos.products') do
        Order::Repositories::Read::ProductRepo.new(
          container['persistence']
        )
      end
    end
  end
end
