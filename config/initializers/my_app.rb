MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  container.register('controllers.users_controller') do
    UsersController.new(
      container['repositories.users'],
      container['services.users_service']
    )
  end

  container.register('services.users_service') do
    Customer::Services::UsersService.new(
      container['services.create_user_service'],
      container['services.update_user_service']
    )
  end

  container.register('controllers.products_controller') do
    ProductsController.new(
      container['repositories.products'],
      container['generators.draft_order_generator'],
      container['services.products_service']
    )
  end

  container.register('services.products_service') do
    Product::Services::ProductsService.new(
      container['services.add_product_service'],
      container['services.update_product_service']
    )
  end

  container.register('controllers.basket_controller') do
    BasketController.new(
      container['generators.draft_order_generator'],
      container['services.basket_service']
    )
  end

  container.register('services.basket_service') do
    Order::Services::BasketService.new(
      container['services.add_products_to_order_service'],
      container['services.change_order_service'],
      container['services.checkout_service']
    )
  end

  container.register('repositories.products') do
    Infrastructure::VersionedRepo.new(
      Product::Repositories::ProductRepo.new(
        container['persistence']
      ),
      Infrastructure::EventRepo[:product].new(
        container['persistence']
      )
    )
  end

  container.register('services.add_product_service') do
    Product::Services::AddProductService.new(
      container['repositories.products']
    )
  end

  container.register('services.update_product_service') do
    Product::Services::UpdateProductService.new(
      container['repositories.products']
    )
  end

  container.register('events.order_checked_out_event_handler') do
    Product::OrderCheckedOutEventHandler.new(
      container['repositories.orders'],
      container['repositories.products']
    )
  end

  container.register('repositories.users') do
    Infrastructure::VersionedRepo.new(
      Customer::Repositories::UserRepo.new(
        container['persistence']
      ),
      Infrastructure::EventRepo[:user].new(
        container['persistence']
      )
    )
  end

  container.register('repositories.baskets') do
    Customer::Repositories::BasketRepo.new(
      container['persistence']
    )
  end

  container.register('services.create_user_service') do
    Customer::Services::CreateUserService.new(
      container['repositories.users']
    )
  end

  container.register('services.update_user_service') do
    Customer::Services::UpdateUserService.new(
      container['repositories.users']
    )
  end

  container.register('repositories.discounts') do
    Order::Repositories::DiscountRepo.new(
      container['persistence']
    )
  end

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

  container.register('generators.draft_order_generator') do
    Order::Generators::DraftOrderGenerator.new(
      container['repositories.products'],
      container['repositories.orders'],
      container['repositories.baskets']
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

  container.register('services.basket_calculator') do
    Customer::ReadModels::Services::BasketCalculator.new(
      container['services.pricing_service'],
      container['services.discount_service']
    )
  end

  container.register('events.order_view_model_generator') do
    Order::OrderViewModelGenerator.new(
      container['repositories.baskets'],
      container['repositories.orders'],
      container['repositories.products'],
      container['services.basket_calculator']
    )
  end

  container.register('events.order_process_manager_router') do
    Order::ProcessManagers::OrderProcessManagerRouter.new(
      container['repositories.order_process_managers']
    )
  end

  Infrastructure::CommandBus.register_command_handler(
    'Order::Commands::CreateOrderCommand'
  ) do
    container['commands.create_order_command_handler']
  end

  Infrastructure::CommandBus.register_command_handler(
    'Order::Commands::ApplyDiscountsCommand'
  ) do
    container['commands.apply_discounts_command_handler']
  end

  Infrastructure::CommandBus.register_command_handler(
    'Order::Commands::AddProductsCommand'
  ) do
    container['commands.add_products_command_handler']
  end

  Infrastructure::CommandBus.register_command_handler(
    'Order::Commands::ChangeOrderCommand'
  ) do
    container['commands.change_order_command_handler']
  end

  Infrastructure::CommandBus.register_command_handler(
    'Order::Commands::CheckoutOrderCommand'
  ) do
    container['commands.checkout_order_command_handler']
  end

  Infrastructure::CommandBus.finalize

  Infrastructure::EventBus.register_event_handler(
    'order_created'
  ) do
    [
      container['events.order_process_manager_router']
    ]
  end

  Infrastructure::EventBus.register_event_handler(
    'products_added'
  ) do
    [
      container['events.order_process_manager_router'],
      container['events.order_view_model_generator']
    ]
  end

  Infrastructure::EventBus.register_event_handler(
    'order_changed'
  ) do
    [
      container['events.order_process_manager_router'],
      container['events.order_view_model_generator']
    ]
  end

  Infrastructure::EventBus.register_event_handler(
    'order_checked_out'
  ) do
    [
      container['events.order_process_manager_router'],
      container['events.order_view_model_generator'],
      container['events.order_checked_out_event_handler']
    ]
  end

  Infrastructure::EventBus.finalize
end
