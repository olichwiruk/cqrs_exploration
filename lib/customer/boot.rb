# frozen_string_literal: true

module Customer
  class Boot
    def self.call(container)
      container.register('customer.repositories.event_repo') do
        Infrastructure::EventRepo[:user].new(
          container['persistence'],
          container['event_bus']
        )
      end

      container.register('customer.repositories.users') do
        Infrastructure::VersionedRepo.new(
          Customer::Repositories::UserRepo.new(
            container['persistence']
          ),
          container['customer.repositories.event_repo']
        )
      end

      container.register('customer.repositories.baskets') do
        Customer::Repositories::BasketRepo.new(
          container['persistence']
        )
      end

      container.register('customer.services.users_service') do
        Customer::Services::UsersService.new(
          container['customer.services.create_user_service'],
          container['customer.services.update_user_service']
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

      container.register('customer.integration.order_updated') do
        Customer::Integration::OrderUpdatedHandler.new(
          container['customer.repositories.baskets'],
          container['customer.read_repos.orders']
        )
      end

      container.register('customer.integration.order_checked_out') do
        Customer::Integration::OrderCheckedOutHandler.new(
          container['customer.repositories.baskets'],
          container['customer.repositories.users'],
          container['customer.read_repos.orders']
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
