MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  command_bus = Infrastructure::CommandBus.new
  event_bus = Infrastructure::EventBus.new

  container.register('command_bus') do
    command_bus
  end

  container.register('event_bus') do
    event_bus
  end

  container.register('controllers.users_controller') do
    UsersController.new(
      container['customer.repositories.users'],
      container['customer.services.users_service']
    )
  end

  container.register('controllers.products_controller') do
    ProductsController.new(
      container['product.repositories.products'],
      container['order.generators.draft_order_generator'],
      container['product.services.products_service']
    )
  end

  container.register('controllers.basket_controller') do
    BasketController.new(
      container['order.generators.draft_order_generator'],
      container['customer.services.basket_service']
    )
  end

  Customer::Boot.call(container)
  Product::Boot.call(container)
  Order::Boot.call(container)

  command_bus.register 'Order::Commands::CreateOrderCommand' do
    container['order.commands.create_order_command_handler']
  end

  command_bus.register 'Order::Commands::ApplyDiscountsCommand' do
    container['order.commands.apply_discounts_command_handler']
  end

  command_bus.register 'Order::Commands::AddProductsCommand' do
    container['order.commands.add_products_command_handler']
  end

  command_bus.register 'Order::Commands::ChangeOrderCommand' do
    container['order.commands.change_order_command_handler']
  end

  command_bus.register 'Order::Commands::CheckoutOrderCommand' do
    container['order.commands.checkout_order_command_handler']
  end

  command_bus.finalize

  event_bus.register 'order_created' do
    [
      container['order.events.order_process_manager_router']
    ]
  end

  event_bus.register 'products_added' do
    [
      container['order.events.order_process_manager_router']
    ]
  end

  event_bus.register 'order_changed' do
    [
      container['order.events.order_process_manager_router']
    ]
  end

  event_bus.register 'order_checked_out' do
    [
      container['order.events.order_process_manager_router']
    ]
  end

  event_bus.register 'order_updated_integration' do
    [
      container['customer.integration.order_updated']
    ]
  end

  event_bus.register 'order_checked_out_integration' do
    [
      container['customer.integration.order_checked_out'],
      container['product.integration.order_checked_out']
    ]
  end

  event_bus.register 'product_price_changed' do
    [
      container['order.integration.product_price_changed']
    ]
  end

  event_bus.finalize
end
