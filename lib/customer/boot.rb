# frozen_string_literal: true

module Customer
  class Boot
    def self.call(container)
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

      container.register('services.basket_calculator') do
        Customer::ReadModels::Services::BasketCalculator.new(
          container['services.pricing_service'],
          container['services.discount_service']
        )
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

      container.register('controllers.basket_controller') do
        BasketController.new(
          container['generators.draft_order_generator'],
          container['services.basket_service']
        )
      end

      container.register('services.basket_service') do
        Customer::Services::BasketService.new(
          container['services.add_products_to_order_service'],
          container['services.change_order_service'],
          container['services.checkout_service']
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

      container.register('events.basket_generator') do
        Customer::ReadModels::Generators::BasketGenerator.new(
          container['repositories.baskets'],
          container['repositories.orders'],
          container['repositories.products'],
          container['services.basket_calculator']
        )
      end
    end
  end
end
