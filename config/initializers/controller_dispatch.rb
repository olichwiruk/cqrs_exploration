# frozen_string_literal: true

module ActionController
  class Metal
    def self.dispatch(name, req, res)
      instance = MyApp.instance
        .container["controllers.#{self.name.underscore}"]

      if middleware_stack.any?
        middleware_stack.build(name) { |env| instance.dispatch(name, req, res) }.call req.env
      else
        instance.dispatch(name, req, res)
      end
    end
  end
end
