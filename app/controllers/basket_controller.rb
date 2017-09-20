# frozen_string_literal: true

class BasketController < ApplicationController
  include Infrastructure::ResultHandler

  def index; end

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
            products: Infrastructure::Repositories::ProductsRepository.all_products,
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
