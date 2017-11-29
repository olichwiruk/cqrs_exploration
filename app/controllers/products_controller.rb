# frozen_string_literal: true

class ProductsController < ApplicationController
  include Infrastructure::ResultHandler

  def index
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/products/index.html.erb',
      view_model: Product::ProductsListViewModel.new(
        products: container['repositories.products'].products.to_a,
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
    @view_model ||= Product::AddProductViewModel.new(
      product: Product::ReadModels::Product.new,
      csrf_token: form_authenticity_token
    )
  end

  def create
    result = container['services.add_product_service'].call(params[:product])

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to products_path
      end

      handler.on_failure = proc do |errors|
        update_add_product_view_model(
          product: Product::ReadModels::Product.new(
            params[:product].to_h
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
    @view_model ||= Product::AddProductViewModel.new(
      product: Product::ReadModels::Product.new(
        container['repositories.products'].by_id(params[:id])
      ),
      csrf_token: form_authenticity_token
    )
  end

  def update
    result = container['services.update_product_service']
      .call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to products_path
      end

      handler.on_failure = proc do |errors|
        update_edition_view_model(
          product: Product::ReadModels::Product.new(
            params[:product].merge(id: params[:id]).to_h
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
