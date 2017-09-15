# frozen_string_literal: true

class ProductsController < ApplicationController
  include Infrastructure::ResultHandler
  ProductsRepo = Infrastructure::Repositories::ProductsRepository

  def index
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/products/index.html.erb',
      view_model: Products::ProductsListViewModel.new(
        products: ProductsRepo.all_products,
        current_user_id: session[:user_id]
      )
    ).html_safe
  end
end
