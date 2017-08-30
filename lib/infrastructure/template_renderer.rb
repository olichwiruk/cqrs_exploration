# frozen_string_literal: true

module Infrastructure
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
      erb = ERB.new(upload_template)

      erb.result(binding)
    end

    # @api private
    def upload_template
      File.read(template)
    rescue => err
      p err.message
      raise "File can't be read"
    end
  end
end
