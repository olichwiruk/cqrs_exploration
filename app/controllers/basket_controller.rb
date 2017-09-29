# frozen_string_literal: true

class BasketController < ApplicationController
  include Infrastructure::ResultHandler

  OrdersRepo = Infrastructure::Repositories::OrdersRepository
  ProductsRepo = Infrastructure::Repositories::ProductsRepository
  BasketsRepo = Infrastructure::RepositoriesRead::BasketsRepository

  def index
    user_id = session[:user_id]
    order = OrdersRepo.find_current(user_id)
    basket = BasketsRepo.find_by(order_id: order.id)
    products = []
    unless basket&.products.nil?
      basket.products.each do |id, quantity|
        products << ProductsRepo.find(id)
          .instance_variable_get(:@fields)
          .merge('quantity' => quantity)
      end
      total = basket.total_price * (1 - basket.discount / 100.0)
    end

    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/basket/index.html.erb',
      view_model: Basket::BasketViewModel.new(
        order_id: order.id,
        products: products,
        discount: basket.discount,
        total: total || 0,
        csrf_token: form_authenticity_token
      )
    ).html_safe
  end

  def create
    result = Order::Services::AddProductsToOrderService.call(
      params.merge(
        user_id: session[:user_id].to_i
      ).permit!
    )

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to basket_index_path
      end

      handler.on_failure = proc do |errors|
        render html: Infrastructure::TemplateRenderer.render(
          template: 'app/views/products/index.html.erb',
          view_model: Products::ProductsListViewModel.new(
            products: ProductsRepo.all,
            basket_hash: params[:products],
            current_user_id: session[:user_id],
            csrf_token: form_authenticity_token,
            errors: errors
          )
        ).html_safe
      end
    end
  end

  def update
    result = Order::Services::ChangeOrderService.call(params.permit!)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to basket_index_path
      end

      handler.on_failure = proc do |errors|
        basket = BasketsRepo.find_by(order_id: params['id'])
        products = []
        unless basket&.products.nil?
          basket.products.each do |id, quantity|
            products << ProductsRepo.find(id)
              .instance_variable_get(:@fields)
              .merge('quantity' => params.to_h['products'][id.to_s].to_i)
          end
          total = basket.total_price * (1 - basket.discount / 100.0)
        end

        render html: Infrastructure::TemplateRenderer.render(
          template: 'app/views/basket/index.html.erb',
          view_model: Basket::BasketViewModel.new(
            order_id: params['id'],
            products: products,
            discount: basket.discount,
            total: total || 0,
            errors: errors,
            csrf_token: form_authenticity_token
          )
        ).html_safe
      end
    end
  end
end
