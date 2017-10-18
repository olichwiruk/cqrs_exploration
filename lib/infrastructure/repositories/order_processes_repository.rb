# frozen_string_literal: true

module Infrastructure
  module Repositories
    class OrderProcessesRepository
      class << self
        # write
        def save(pm)
          values = pm.instance_variable_get(:@fields)
            .without('commands')
          process = AR::OrderProcess.find_by(order_uuid: pm.order_uuid)
          if process.nil?
            AR::OrderProcess.new(values).save
          else
            process.update_attributes(values)
          end
        end

        # read
        def load(order_uuid)
          Order::ProcessManagers::OrderProcessManager.new(
            AR::OrderProcess.find_by(order_uuid: order_uuid)
          )
        end

        def build(params)
          Order::ProcessManagers::OrderProcessManager.new(
            AR::OrderProcess.new(params)
          )
        end
      end
    end
  end
end
