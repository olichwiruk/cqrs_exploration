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

  def new
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/products/new.html.erb',
      view_model: add_product_view_model
    ).html_safe
  end

  def add_product_view_model
    @view_model ||= Products::AddProductViewModel.new(
      product: ProductsRepo.build(nil),
      csrf_token: form_authenticity_token
    )
  end

  def create
    result = AddProductService.call(params[:product].permit!)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to products_path
      end

      handler.on_failure = proc do |errors|
        update_add_product_view_model(
          product: ProductsRepo.build(
            name: params[:product][:name],
            quantity: params[:product][:quantity],
            price: params[:product][:price]
          ),
          csrf_token: form_authenticity_token,
          errors: errors
        )
        new
      end
    end
  end

  def update_add_product_view_model(**options)
    @view_model = add_product_view_model.update(options)
  end
end
