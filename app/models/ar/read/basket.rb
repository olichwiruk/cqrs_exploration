# frozen_string_literal: true

module AR
  module Read
    class Basket < ActiveRecord::Base
      self.table_name = 'r.baskets'
    end
  end
end
