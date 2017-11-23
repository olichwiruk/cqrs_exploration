MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  container.register('persistence.commands.users') do
    container['persistence'].command(:users)
  end

  container.register('persistence.commands.create_user') do
    container['persistence.commands.users'][:create]
  end

  container.register('repositories.products') do
    Product::Repositories::ProductRepo.new(container['persistence'])
  end

  container.register('services.add_product_service') do
    Product::Services::AddProductService.new(container['repositories.products'])
  end
end
