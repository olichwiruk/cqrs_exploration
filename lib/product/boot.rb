# frozen_string_literal: true

module Product
  class Boot
    def self.call(container)
      container.register('product.repositories.products') do
        Infrastructure::VersionedRepo.new(
          Product::Repositories::ProductRepo.new(
            container['persistence']
          ),
          Infrastructure::EventRepo[:product].new(
            container['persistence']
          )
        )
      end

      container.register('controllers.products_controller') do
        ProductsController.new(
          container['product.repositories.products'],
          container['order.generators.draft_order_generator'],
          container['product.services.products_service']
        )
      end

      container.register('product.services.products_service') do
        Product::Services::ProductsService.new(
          container['product.services.add_product_service'],
          container['product.services.update_product_service']
        )
      end

      container.register('product.services.add_product_service') do
        Product::Services::AddProductService.new(
          container['product.repositories.products']
        )
      end

      container.register('product.services.update_product_service') do
        Product::Services::UpdateProductService.new(
          container['product.repositories.products']
        )
      end

      container.register('product.events.order_checked_out_event_handler') do
        Product::OrderCheckedOutEventHandler.new(
          container['product.read_repos.orders'],
          container['product.repositories.products']
        )
      end

      container.register('product.read_repos.orders') do
        Product::Repositories::Read::OrderRepo.new(
          container['persistence']
        )
      end
    end
  end
end
