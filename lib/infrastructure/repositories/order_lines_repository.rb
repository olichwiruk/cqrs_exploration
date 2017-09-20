# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderLinesRepository
      class << self
        def save(line)
          AR::OrderLine.create!(line.instance_variable_get(:@fields))
        end

        def build(params)
          Order::Domain::OrderLine.new(
            AR::OrderLine.new(params)
          )
        end
      end
    end
  end
end
