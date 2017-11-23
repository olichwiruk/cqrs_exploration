MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  container.register('repositories.write_repo') do
    Infrastructure::Repositories::WriteRepo.new(
      container['persistence']
    )
  end

  container.register('infrastructure.event_store') do
    Infrastructure::EventStore.new(
      container['repositories.write_repo']
    )
  end

  container.register('repositories.products') do
    Product::Repositories::ProductRepo.new(
      container['persistence']
    )
  end

  container.register('services.add_product_service') do
    Product::Services::AddProductService.new(
      container['infrastructure.event_store'],
      container['repositories.products']
    )
  end

  container.register('services.update_product_service') do
    Product::Services::UpdateProductService.new(
      container['infrastructure.event_store'],
      container['repositories.products']
    )
  end

  container.register('services.create_user_service') do
    Customer::Services::CreateUserService.new(
      container['infrastructure.event_store']
    )
  end

  container.register('services.update_user_service') do
    Customer::Services::UpdateUserService.new(
      container['infrastructure.event_store']
    )
  end
end
