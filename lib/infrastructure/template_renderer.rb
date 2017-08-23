# frozen_string_literal: true

class TemplateRenderer
  include Rails.application.routes.url_helpers
  include Formular::Helper

  attr_reader :template, :view_model

  def self.render(**options)
    new(options).call
  end

  def initialize(template:, view_model:)
    @template = template
    @view_model = view_model
  end

  def call
    erb = ERB.new(File.read(template))

    erb.result(binding)
  end
end
