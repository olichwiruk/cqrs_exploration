MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  container.register('repositories.event_repo') do
    Infrastructure::EventRepo.new(
      container['persistence']
    )
  end

  container.register('repositories.products') do
    Product::Repositories::ProductRepo.new(
      container['persistence']
    )
  end

  container.register('services.add_product_service') do
    Product::Services::AddProductService.new(
      container['repositories.event_repo'],
      container['repositories.products']
    )
  end

  container.register('services.update_product_service') do
    Product::Services::UpdateProductService.new(
      container['repositories.event_repo'],
      container['repositories.products']
    )
  end

  container.register('repositories.users') do
    Customer::Repositories::UserRepo.new(
      container['persistence']
    )
  end

  container.register('services.create_user_service') do
    Customer::Services::CreateUserService.new(
      container['repositories.event_repo'],
      container['repositories.users']
    )
  end

  container.register('services.update_user_service') do
    Customer::Services::UpdateUserService.new(
      container['repositories.event_repo']
    )
  end
end
