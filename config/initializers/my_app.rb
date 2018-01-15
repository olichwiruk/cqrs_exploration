MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  Customer::Boot.call(container)
  Product::Boot.call(container)
  Order::Boot.call(container)

  Infrastructure::CommandBus.register(container)
  Infrastructure::EventBus.register(container)
end
