# frozen_string_literal: true

class ProductsController < ApplicationController
  include Infrastructure::ResultHandler
  ProductsRepo = Infrastructure::Repositories::ProductsRepository

  def index
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/products/index.html.erb',
      view_model: Products::ProductsListViewModel.new(
        products: ProductsRepo.all,
        current_user_id: session[:user_id],
        csrf_token: form_authenticity_token
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
      product: Product::ReadModels::Product.new,
      csrf_token: form_authenticity_token
    )
  end

  def create
    result = Product::Services::AddProductService.call(params[:product].permit!)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to products_path
      end

      handler.on_failure = proc do |errors|
        update_add_product_view_model(
          product: Product::ReadModels::Product.new(
            params[:product]
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

  def edit
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/products/edit.html.erb',
      view_model: edition_view_model
    ).html_safe
  end

  def edition_view_model
    @view_model ||= Products::AddProductViewModel.new(
      product: Product::ReadModels::Product.new(
        AR::Product.find(params[:id]).attributes
      ),
      csrf_token: form_authenticity_token
    )
  end

  def update
    result = Product::Services::UpdateProductService.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to products_path
      end

      handler.on_failure = proc do |errors|
        update_edition_view_model(
          product: Product::ReadModels::Product.new(
            params[:product].merge(id: params[:id]).permit!
          ),
          csrf_token: form_authenticity_token,
          errors: errors
        )
        edit
      end
    end
  end

  def update_edition_view_model(**options)
    @view_model = edition_view_model.update(options)
  end
end
