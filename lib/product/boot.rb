# frozen_string_literal: true

module Product
  class Boot
    def self.call(container)
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
    end
  end
end
