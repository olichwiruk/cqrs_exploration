# frozen_string_literal: true

class BasketController < ApplicationController
  include Infrastructure::ResultHandler

  attr_reader :draft_order, :basket_service

  def initialize(draft_order, basket_service)
    @draft_order = draft_order
    @basket_service = basket_service
    super()
  end

  def index
    render html: Infrastructure::TemplateRenderer.render(
      template: 'app/views/basket/index.html.erb',
      view_model: Basket::BasketViewModel.new(
        draft_order: draft_order.with_ordered_products(session[:user_id]),
        csrf_token: form_authenticity_token
      )
    ).html_safe
  end

  def add_products
    result = basket_service.add_products_to_order.call(
      params.merge(user_id: session[:user_id])
    )

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to basket_index_path
      end

      handler.on_failure = proc do |validation_result|
        render html: Infrastructure::TemplateRenderer.render(
          template: 'app/views/products/index.html.erb',
          view_model: Product::ProductsListViewModel.new(
            draft_order: draft_order.failure(
              session[:user_id],
              Customer::ReadModels::NullBasket.new(
                validation_result.output[:products]
              )
            ),
            csrf_token: form_authenticity_token,
            errors: validation_result.errors
          )
        ).html_safe
      end
    end
  end

  def update
    result = basket_service.change_order.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to basket_index_path
      end

      handler.on_failure = proc do |validation_result|
        render html: Infrastructure::TemplateRenderer.render(
          template: 'app/views/basket/index.html.erb',
          view_model: Basket::BasketViewModel.new(
            draft_order: draft_order.failure(
              session[:user_id],
              Customer::ReadModels::NullBasket.new(
                validation_result.output[:products]
              )
            ),
            errors: validation_result.errors,
            csrf_token: form_authenticity_token
          )
        ).html_safe
      end
    end
  end

  def checkout
    result = basket_service.checkout.call(params)

    handle_op_result(result: result) do |handler|
      handler.on_success = lambda do
        redirect_to products_path
      end

      handler.on_failure = proc do |validation_result|
        render html: Infrastructure::TemplateRenderer.render(
          template: 'app/views/basket/index.html.erb',
          view_model: Basket::BasketViewModel.new(
            draft_order: draft_order.with_ordered_products(session[:user_id]),
            errors: validation_result.errors,
            csrf_token: form_authenticity_token
          )
        ).html_safe
      end
    end
  end
end
