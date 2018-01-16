# frozen_string_literal: true

module Customer
  class Boot
    def self.call(container)
      container.register('customer.repositories.users') do
        Infrastructure::VersionedRepo.new(
          Customer::Repositories::UserRepo.new(
            container['persistence']
          ),
          Infrastructure::EventRepo[:user].new(
            container['persistence']
          )
        )
      end

      container.register('customer.repositories.baskets') do
        Customer::Repositories::BasketRepo.new(
          container['persistence']
        )
      end

      container.register('customer.services.basket_calculator') do
        Customer::ReadModels::Services::BasketCalculator.new(
          container['order.services.pricing_service'],
          container['order.services.discount_service']
        )
      end

      container.register('controllers.users_controller') do
        UsersController.new(
          container['customer.repositories.users'],
          container['customer.services.users_service']
        )
      end

      container.register('customer.services.users_service') do
        Customer::Services::UsersService.new(
          container['customer.services.create_user_service'],
          container['customer.services.update_user_service']
        )
      end

      container.register('controllers.basket_controller') do
        BasketController.new(
          container['order.generators.draft_order_generator'],
          container['customer.services.basket_service']
        )
      end

      container.register('customer.services.basket_service') do
        Customer::Services::BasketService.new(
          container['order.services.add_products_to_order_service'],
          container['order.services.change_order_service'],
          container['order.services.checkout_service']
        )
      end

      container.register('customer.services.create_user_service') do
        Customer::Services::CreateUserService.new(
          container['customer.repositories.users']
        )
      end

      container.register('customer.services.update_user_service') do
        Customer::Services::UpdateUserService.new(
          container['customer.repositories.users']
        )
      end

      container.register('customer.events.basket_generator') do
        Customer::ReadModels::Generators::BasketGenerator.new(
          container['customer.repositories.baskets'],
          container['customer.read_repos.orders'],
          container['customer.read_repos.products'],
          container['customer.services.basket_calculator']
        )
      end

      container.register('customer.events.order_checked_out_event_handler') do
        Customer::OrderCheckedOutEventHandler.new(
          container['customer.read_repos.orders'],
          container['customer.repositories.users']
        )
      end

      container.register('customer.read_repos.orders') do
        Customer::Repositories::Read::OrderRepo.new(
          container['persistence']
        )
      end

      container.register('customer.read_repos.products') do
        Customer::Repositories::Read::ProductRepo.new(
          container['persistence']
        )
      end
    end
  end
end
