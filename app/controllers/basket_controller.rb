# frozen_string_literal: true

class BasketController < ApplicationController
  include Infrastructure::ResultHandler

  OrdersRepo = Infrastructure::Repositories::OrdersRepository
  ProductsRepo = Infrastructure::Repositories::ProductsRepository
  OrderLinesRepo = Infrastructure::Repositories::OrderLinesRepository

  def index
    user_id = session[:user_id]
    order = OrdersRepo.find_current(user_id)
    products = OrderLinesRepo.basket(order_id: order.id)

    total = products.sum { |p| p['price'] * p['quantity'] } * (1 - order.discount / 100.0)

    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/basket/index.html.erb',
      view_model: Basket::BasketViewModel.new(
        products: products,
        discount: order.discount,
        total: total,
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
end
