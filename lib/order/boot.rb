# frozen_string_literal: true

module Order
  class Boot
    def self.call(container)
      container.register('repositories.orders') do
        Infrastructure::VersionedRepo.new(
          Order::Repositories::OrderRepo.new(
            container['persistence']
          ),
          Infrastructure::EventRepo[:order].new(
            container['persistence']
          )
        )
      end

      container.register('repositories.order_process_managers') do
        Order::Repositories::OrderProcessManagerRepo.new(
          container['persistence']
        )
      end

      container.register('repositories.discounts') do
        Order::Repositories::DiscountRepo.new(
          container['persistence']
        )
      end

      container.register('services.pricing_service') do
        Order::Services::Domain::PricingService.new
      end

      container.register('services.discount_service') do
        Order::Services::Domain::DiscountService.new(
          container['repositories.users'],
          container['repositories.products'],
          container['repositories.orders'],
          container['repositories.discounts'],
          container['services.pricing_service']
        )
      end

      container.register('generators.draft_order_generator') do
        Order::Generators::DraftOrderGenerator.new(
          container['repositories.products'],
          container['repositories.orders'],
          container['repositories.baskets']
        )
      end

      container.register('services.add_products_to_order_service') do
        Order::Services::AddProductsToOrderService.new(
          container['repositories.orders'],
          container['repositories.products']
        )
      end

      container.register('services.change_order_service') do
        Order::Services::ChangeOrderService.new(
          container['repositories.orders'],
          container['repositories.products']
        )
      end

      container.register('services.checkout_service') do
        Order::Services::CheckoutService.new(
          container['repositories.users'],
          container['repositories.baskets'],
          container['repositories.orders']
        )
      end

      container.register('commands.create_order_command_handler') do
        Order::CommandHandlers::CreateOrderCommandHandler.new(
          container['repositories.orders']
        )
      end

      container.register('commands.add_products_command_handler') do
        Order::CommandHandlers::AddProductsCommandHandler.new(
          container['repositories.orders'],
          container['repositories.products']
        )
      end

      container.register('commands.change_order_command_handler') do
        Order::CommandHandlers::ChangeOrderCommandHandler.new(
          container['repositories.orders'],
          container['repositories.products']
        )
      end

      container.register('commands.checkout_order_command_handler') do
        Order::CommandHandlers::CheckoutOrderCommandHandler.new(
          container['repositories.orders']
        )
      end

      container.register('commands.apply_discounts_command_handler') do
        Order::CommandHandlers::ApplyDiscountsCommandHandler.new(
          container['repositories.orders'],
          container['services.discount_service']
        )
      end

      container.register('events.order_process_manager_router') do
        Order::ProcessManagers::OrderProcessManagerRouter.new(
          container['repositories.order_process_managers']
        )
      end
    end
  end
end
